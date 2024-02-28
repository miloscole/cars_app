class RenameCarsColumnName < ActiveRecord::Migration[7.1]
  def change
    rename_column :cars, :name, :brand
  end
end
