class CreateReservations < ActiveRecord::Migration[7.1]
  def change
    create_table :reservations do |t|
      t.date :reservation_date
      t.references :user, null: false, foreign_key: true
      t.references :seat, null: false, foreign_key: true
      t.references :bus, null: false, foreign_key: true
      t.timestamps
    end
  end
end
