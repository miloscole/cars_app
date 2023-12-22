class CreateEngines < ActiveRecord::Migration[7.1]
  def change
    create_table :engines do |t|
      t.belongs_to :car, foreign_key: true
      t.string :fuel_type
      t.float :displacement
      t.integer :power
      t.integer :cylinders_num

      t.timestamps
    end
  end
end
