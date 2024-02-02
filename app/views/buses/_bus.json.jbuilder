json.extract! bus, :id, :name, :registration_number, :route_source, :route_destination, :total_seats, :bus_owner_id, :departure_time, :arrival_time, :created_at, :updated_at
json.url bus_url(bus, format: :json)
