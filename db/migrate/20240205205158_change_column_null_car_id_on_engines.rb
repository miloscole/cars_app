class ChangeColumnNullCarIdOnEngines < ActiveRecord::Migration[7.1]
  def change
    change_column_null :engines, :car_id, false
  end
end
