require 'date'

class Rental
  module OptionTypes
    GPS = 'gps'.freeze
    BABY_SEAT = 'baby_seat'.freeze
    ADDITIONAL_INSURANCE = 'additional_insurance'.freeze
  end

  ASSISTANCE_FEE_PER_DAY = 100
  GPS_PRICE_PER_DAY = 500
  BABY_SEAT_PRICE_PER_DAY = 200
  ADDITIONAL_INSURANCE_FEE_PER_DAY = 1000

  attr_reader :id, :car, :start_date, :end_date, :distance, :options

  def initialize(id, car, start_date, end_date, distance, options)
    @id = id
    @car = car
    @start_date = Date.parse(start_date)
    @end_date = Date.parse(end_date)
    @distance = distance
    @options = options
  end

  def total_price
    @total_price ||= travel_price + gps_fee + baby_seat_fee + additional_insurance_fee
  end

  def credit_for_owner
    @credit_for_owner ||= (travel_price * 0.7).to_i + gps_fee + baby_seat_fee
  end

  def commission_fee
    @commission_fee ||= (travel_price * 0.3).to_i
  end

  def insurance_fee
    @insurance_fee ||= commission_fee / 2
  end

  def assistance_fee
    @assistance_fee ||= duration * ASSISTANCE_FEE_PER_DAY
    raise "assistance_fee is too big" if @assistance_fee > insurance_fee # NOTE: we might want to handle this case differently

    @assistance_fee
  end

  def drivy_fee
    @drivy_fee ||= commission_fee - insurance_fee - assistance_fee + additional_insurance_fee
    raise "drivy_fee is negative" if @drivy_fee.negative? # NOTE: we might want to handle this case differently

    @drivy_fee
  end

  private

  def duration
    (end_date - start_date).to_i + 1
  end

  def travel_price
    @travel_price ||= price_for_duration + price_for_distance
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

  def gps_fee
    @gps_fee ||=
      if @options.include?(OptionTypes::GPS)
        (duration * GPS_PRICE_PER_DAY)
      else
        0
      end
  end

  def baby_seat_fee
    @baby_seat_fee ||=
      if @options.include?(OptionTypes::BABY_SEAT)
        (duration * BABY_SEAT_PRICE_PER_DAY)
      else
        0
      end
  end

  def additional_insurance_fee
    @additional_insurance_fee ||=
      if @options.include?(OptionTypes::ADDITIONAL_INSURANCE)
        duration * ADDITIONAL_INSURANCE_FEE_PER_DAY
      else
        0
      end
  end
end
