class AddNullFalseToCustomerFields < ActiveRecord::Migration[7.0]
  def change
    change_column_null :customers, :first_name, false
    change_column_null :customers, :last_name, false
    change_column_null :customers, :email, false
  end
end
