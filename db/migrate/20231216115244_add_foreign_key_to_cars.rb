class AddForeignKeyToCars < ActiveRecord::Migration[7.0]
  def change
    add_column :cars, :customer_id, :bigint
    add_foreign_key :cars, :customers
  end
end
