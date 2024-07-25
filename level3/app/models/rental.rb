require 'date'

class Rental
  ASSISTANCE_PRICE_PER_DAY = 100

  attr_reader :id, :car, :start_date, :end_date, :distance

  def initialize(id, car, start_date, end_date, distance)
    @id = id
    @car = car
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance
  end

  def price
    @price ||= price_for_duration + price_for_distance
  end

  def commission_price
    @commission_price ||= (price * 0.3).to_i
  end

  def insurance_fee
    @insurance_fee ||= commission_price / 2
  end

  def assistance_fee
    @assistance_fee ||= duration * ASSISTANCE_PRICE_PER_DAY
    raise "assistance_fee is too big" if @assistance_fee > insurance_fee # NOTE: we might want to handle this case differently

    @assistance_fee
  end

  def drivy_fee
    @drivy_fee ||= (commission_price - insurance_fee - assistance_fee)
    raise "drivy_fee is negative" if @drivy_fee.negative? # NOTE: we might want to handle this case differently

    @drivy_fee
  end

  private

  def duration
    (end_date - start_date).to_i + 1
  end

  def price_for_duration
    result = 0

    duration.times do |day|
      if day < 1
        result += car.price_per_day
      elsif day < 4
        result += (car.price_per_day * 0.9)
      elsif day < 10
        result += (car.price_per_day * 0.7)
      else
        result += (car.price_per_day * 0.5)
      end
    end

    result.to_i
  end

  def price_for_distance
    distance * car.price_per_km
  end
end
