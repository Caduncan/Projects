class User < ActiveRecord::Base
  include SluggableArthur

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 4 }, on: :create
  validates :password, allow_blank: true, length: { minimum: 4 }, on: :update
  validates :role, presence: true

  after_initialize :default

  sluggable_column :username

  def has_role?(role)
    self.role == role
  end

  def admin?
    has_role?('admin')
  end

  def moderator?
    has_role?('moderator')
  end

  private

    def default
      self.role ||= 'moderator'
    end
end