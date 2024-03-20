class Engine < ApplicationRecord
  enum fuel_type: { gasoline: "gasoline", diesel: "diesel" }
  enum displacement: { "1.2": 1.2, "1.4": 1.4, "1.6": 1.6, "1.8": 1.8 }
  enum cylinders_num: { "8": 8, "16": 16 }
  enum power: { "60": 60, "100": 100, "150": 150, "200": 200 }
  belongs_to :car

  validates :fuel_type, :displacement, :power, :cylinders_num, presence: true
end
