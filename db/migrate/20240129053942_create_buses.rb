class CreateBuses < ActiveRecord::Migration[7.1]
  def change
    create_table :buses do |t|
      t.string :name
      t.string :registration_number
      t.string :route_source
      t.string :route_destination
      t.integer :total_seats
      t.references :bus_owner, foreign_key: { to_table: :users }
      t.datetime :departure_time
      t.datetime :arrival_time

      t.timestamps
    end
  end
end