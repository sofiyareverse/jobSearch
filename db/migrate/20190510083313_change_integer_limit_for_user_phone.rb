class ChangeIntegerLimitForUserPhone < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :phone, :integer, limit: 8
  end
end
