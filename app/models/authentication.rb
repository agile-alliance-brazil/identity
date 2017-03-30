# encoding: UTF-8

# Represents an authentication coming from OAuth
class Authentication < ActiveRecord::Base
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
  validates :user, presence: true
end
