class AddUserIdToCustomersAndCars < ActiveRecord::Migration[7.1]
  def change
    add_column :customers, :user_id, :bigint, null: false
    add_foreign_key :customers, :users
    add_column :cars, :user_id, :bigint, null: false
    add_foreign_key :cars, :users
  end
end
