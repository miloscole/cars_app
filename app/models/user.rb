class User < ApplicationRecord
  has_many :customers, dependent: :destroy
  has_many :cars, dependent: :destroy
  has_secure_password

  USERNAME_REGEX = /\A[\w]+\z/

  validates :email, presence: true, uniqueness: true,
                    format: { with: EMAIL_REGEX, message: :invalid }
  validates :username, presence: true, uniqueness: true,
                       length: { minimum: 3, maximum: 15 },
                       format: { with: USERNAME_REGEX, message: :invalid }
  validates :password, presence: true, length: { minimum: 6 }

  before_save :downcase_attributes

  private

  def downcase_attributes
    username.downcase!
    email.downcase!
  end
end
