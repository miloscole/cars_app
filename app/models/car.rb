class Car < ApplicationRecord
  belongs_to :customer, optional: true
  has_one :engine, dependent: :destroy
  accepts_nested_attributes_for :engine, allow_destroy: true

  validates :name, presence: true
  validates :model, presence: true
  validates :production_year, presence: true
  validates :price, presence: true

  def full_name
    self.name + " " + self.model
  end
end
