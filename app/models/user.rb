# encoding: UTF-8
class User < ActiveRecord::Base
  AUTH_PROVIDERS = Rails.application.secrets.omniauth.keys
  devise :database_authenticatable, :registerable, :recoverable,
    :trackable, :validatable, :omniauthable, omniauth_providers: AUTH_PROVIDERS

  has_many :authentications, dependent: :destroy

  normalize_attributes :first_name, :last_name, :email, :username, :twitter_username,
    :phone, :city, :state, :country, :bio, :website_url, :organization

  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }
  validates :organization, length: { maximum: 100 }, allow_blank: true
  validates :website_url, length: { maximum: 100 }, allow_blank: true
  validates :username, length: { within: 3..30 }, format: { with: /\A\w[\w\.+-_@ ]+\z/, message: :username_format }, uniqueness: { case_sensitive: false }, constant: { on: :update }
  validates :email, length: { within: 6..100 }

  before_validation do |user|
    user.twitter_username = user.twitter_username[1..-1] if user.twitter_username =~ /\A@/
    user.state = nil unless in_brazil?
  end

  scope :search, lambda { |q| where("username LIKE ?", "%#{q}%") }

  def self.from_omniauth(auth)
    authentication = Authentication.where(provider: auth[:provider], uid: auth[:uid]).first
    if authentication
      authentication.user
    else
      user = User.find_by_email(auth[:info][:email])
      unless user
        user = User.from_auth_info(auth[:info])
        user.password = Devise.friendly_token[8,30]
      end
      user.authentications.build(provider: auth[:provider], uid: auth[:uid])
      user.save
      user
    end
  end

  def self.from_auth_info(info)
    user = User.new
    if info
      user.email = info[:email]
      user.username = user.email
      names = info[:name].try(:split, /\s/)
      user.first_name = names.try(:first)
      user.last_name = names.try(:last)
    end
    user
  end

  def full_name
    [self.first_name, self.last_name].join(' ')
  end

  def to_param
    username.blank? ? super : "#{id}-#{username.parameterize}"
  end

  private

  def in_brazil?
    self.country == "BR"
  end
end