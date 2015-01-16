class Post < ActiveRecord::Base
  include VoteableArthur
  include SluggableArthur

  belongs_to :creator, class_name: 'User', foreign_key: 'user_id'
  has_many :comments, dependent: :destroy
  has_many :post_categories
  has_many :categories, through: :post_categories

  validates :title, presence: true, length: { minimum: 5, maximum: 120 }
  validates :url, presence: true, length: { maximum: 120 }, uniqueness: true
  validates :description, presence: true

  sluggable_column :title
end