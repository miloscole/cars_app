class Customer < ApplicationRecord
  belongs_to :user
  has_many :cars, dependent: :nullify

  validates :first_name, presence: true, length: { minimum: 2, maximum: 25 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 25 }
  validates :email, presence: true, uniqueness: true,
                    format: {
                      with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
                      message: :invalid,
                    }

  before_save :downcase_email

  def full_name
    self.first_name + " " + self.last_name
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
