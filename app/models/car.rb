class Car < ApplicationRecord
  belongs_to :user
  belongs_to :customer, optional: true
  has_one :engine, dependent: :destroy
  accepts_nested_attributes_for :engine, allow_destroy: true

  validates :brand, presence: true
  validates :model, presence: true
  validates :production_year, presence: true
  validates :price, presence: true

  def full_name
    self.brand + " " + self.model
  end

  validate :customer_belongs_to_current_user

  private

  def customer_belongs_to_current_user
    if customer.present? && customer.user != Current.user
      errors.add(:customer_id, "must belong to the current user")
    end
  end
end
