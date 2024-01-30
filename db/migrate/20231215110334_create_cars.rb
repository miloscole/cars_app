class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :name
      t.string :model
      t.date :production_year
      t.integer :price

      t.timestamps
    end
  end
end
