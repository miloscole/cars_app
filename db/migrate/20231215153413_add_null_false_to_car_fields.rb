class AddNullFalseToCarFields < ActiveRecord::Migration[7.0]
  def change
    change_column_null :cars, :name, false
    change_column_null :cars, :model, false
    change_column_null :cars, :production_year, false
    change_column_null :cars, :price, false
  end
end
