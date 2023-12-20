class Car < ApplicationRecord
  belongs_to :customer, optional: true

  validates :name, presence: true
  validates :model, presence: true
  validates :production_year, presence: true
  validates :price, presence: true

  def full_name
    self.name + " " + self.model
  end
end
