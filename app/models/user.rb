# frozen_string_literal: true
# encoding: UTF-8
# Represents a user in the system
class User < ActiveRecord::Base
  AUTH_PROVIDERS = Rails.application.secrets.omniauth.keys
  SESSION_DATA_KEY = 'devise.omniauth_data'.freeze
  devise :database_authenticatable, :registerable, :recoverable,
         :trackable, :rememberable, :validatable, :omniauthable,
         :confirmable,
         omniauth_providers: AUTH_PROVIDERS, authentication_keys: [:login]

  has_many :authentications, dependent: :destroy

  attr_accessor :login

  normalize_attributes :first_name, :last_name, :email, :username,
                       :twitter_username, :phone, :city, :state,
                       :country, :bio, :website_url, :organization

  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }
  validates :organization, length: { maximum: 100 }, allow_blank: true
  validates :website_url, length: { maximum: 100 }, allow_blank: true
  validates :username,
            length: { within: 3..30 },
            presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: /\A\w[\w\.+-_@ ]+\z/, message: :username_format }
  validates :email, length: { within: 6..100 }

  before_validation do |user|
    if user.twitter_username =~ /\A@/
      user.twitter_username = user.twitter_username[1..-1]
    end
    user.state = nil unless in_brazil?
  end

  scope :search, ->(q) { where('username LIKE ?', "%#{q}%") }

  def self.from_omniauth(auth)
    keys = { provider: auth[:provider], uid: auth[:uid] }
    authentication = Authentication.find_by(keys)
    if authentication
      authentication.user
    else
      user = user_for(auth)
      user.authentications.build(keys)
      user.save
      user
    end
  end

  def self.user_for(auth_data)
    user = User.find_by_email(auth_data[:info][:email])
    if user.nil?
      user = User.from_auth_info(auth_data[:info])
      user.password = Devise.friendly_token[8, 30]
    end
    user
  end

  def self.new_with_session(params, session)
    user = super
    data = session[User::SESSION_DATA_KEY] || {}
    User.from_auth_info(data.with_indifferent_access[:info], user)
  end

  def self.from_auth_info(info, user = User.new)
    if info
      user.email ||= info[:email]
      user.username ||= user.email
      names = info[:name].try(:split, /\s/)
      user.first_name ||= names.try(:first)
      user.last_name ||= names.try(:last)
      user.twitter_username ||= info[:nickname]
    end
    user
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:login))
      where(conditions).find_by([
                                  'username = :value OR email = :value',
                                  value: login.downcase
                                ])
    else
      find_by(conditions)
    end
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def to_param
    username.blank? ? super : "#{id}-#{username.parameterize}"
  end

  private

  def in_brazil?
    country == 'BR'
  end
end
