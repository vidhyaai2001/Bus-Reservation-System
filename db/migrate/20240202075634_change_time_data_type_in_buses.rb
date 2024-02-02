class ChangeTimeDataTypeInBuses < ActiveRecord::Migration[7.1]
  def up
    change_column :buses, :departure_time, :time
    change_column :buses, :arrival_time, :time
  end

  def down
    change_column :buses, :departure_time, :datetime
    change_column :buses, :arrival_time, :datetime
  end
end
