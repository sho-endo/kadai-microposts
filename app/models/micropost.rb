class Micropost < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 255}
  
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user
end
