require 'json'

require './app/models/car'
require './app/models/rental'
require './app/serializers/rental_serializer'

class Getaround
  attr_reader :cars, :rentals

  def initialize(data_file_path)
    data = JSON.parse(File.read(data_file_path))

    @cars = load_cars(data['cars'])
    @rentals = load_rentals(data['rentals'])
  end

  def run(result_file_path)
    rentals_serialization = @rentals.values.map do |rental|
      RentalSerializer.new(rental).as_json
    end

    File.write(result_file_path, JSON.pretty_generate(rentals: rentals_serialization))
  end

  private

  def load_cars(cars_data)
    cars_data.each_with_object({}) do |car_data, result|
      car_id = car_data['id']

      result[car_id] = Car.new(
        car_id,
        car_data['price_per_day'],
        car_data['price_per_km'],
      )
    end
  end

  def load_rentals(rentals_data)
    rentals_data.each_with_object({}) do |rental_data, result|
      rental_id = rental_data['id']
      car_id = rental_data['car_id']

      result[rental_id] = Rental.new(
        rental_id,
        @cars[car_id],
        rental_data['start_date'],
        rental_data['end_date'],
        rental_data['distance'],
      )
    end
  end
end
