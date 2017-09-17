# Represents an authentication coming from OAuth
class Authentication < ApplicationRecord
  belongs_to :user

  validates :provider, presence: true
  validates :uid, presence: true
  validates :user, presence: true
end
