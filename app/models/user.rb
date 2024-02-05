class User < ApplicationRecord
  has_many :customers, dependent: :destroy
  has_many :cars, dependent: :destroy
  has_secure_password

  validates :email, presence: true, uniqueness: true,
                    format: {
                      with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
                      message: :invalid,
                    }
  validates :username, presence: true, uniqueness: true,
                       length: { minimum: 3, maximum: 15 },
                       format: {
                         with: /\A[\w]+\z/,
                         message: :invalid,
                       }
  validates :password, presence: true, length: { minimum: 6 }

  before_save :downcase_attributes

  private

  def downcase_attributes
    self.username = username.downcase
    self.email = email.downcase
  end
end
