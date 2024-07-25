require 'date'

class Rental
  attr_reader :id, :car, :start_date, :end_date, :distance

  def initialize(id, car, start_date, end_date, distance)
    @id = id
    @car = car
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance
  end

  def price
    price_for_duration + price_for_distance
  end

  private

  def duration
    (end_date - start_date).to_i + 1
  end

  def price_for_duration
    duration * car.price_per_day
  end

  def price_for_distance
    distance * car.price_per_km
  end
end
