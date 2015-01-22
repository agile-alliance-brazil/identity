# encoding: UTF-8
class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :trackable, :validatable

  # attr_trimmed    :first_name, :last_name, :username, :email, :twitter_username,
  #                 :phone, :state, :city, :organization, :website_url, :bio

  validates :first_name, presence: true, length: { maximum: 100 }
  validates :last_name, presence: true, length: { maximum: 100 }
  validates :organization, length: { maximum: 100 }, allow_blank: true
  validates :website_url, length: { maximum: 100 }, allow_blank: true
  validates :username, length: { within: 3..30 }, format: { with: /\A\w[\w\.+\-_@ ]+\z/, message: :username_format }, uniqueness: { case_sensitive: false }
  validates :email, length: { within: 6..100 }, allow_blank: true

  before_validation do |user|
    user.twitter_username = user.twitter_username[1..-1] if user.twitter_username =~ /\A@/
    user.state = '' unless in_brazil?
  end

  scope :search, lambda { |q| where("username LIKE ?", "%#{q}%") }

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