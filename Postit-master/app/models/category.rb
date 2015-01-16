class Category < ActiveRecord::Base
  include SluggableArthur

  has_many :post_categories
  has_many :posts, through: :post_categories

  validates :name, presence: true, length: { maximum: 20 }, uniqueness: { case_sensitive: false }

  sluggable_column :name

end