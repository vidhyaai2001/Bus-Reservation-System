class RemoveColumnToSeat < ActiveRecord::Migration[7.1]
  def up
    remove_column :seats, :status, :string
  end

  def down
    add_column :seats, :status, :string
  end
end
