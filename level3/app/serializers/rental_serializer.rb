class RentalSerializer
  def initialize(rental)
    @rental = rental
  end

  def as_json
    {
      id: @rental.id,
      price: @rental.price,
      commission: {
        insurance_fee: @rental.insurance_fee,
        assistance_fee: @rental.assistance_fee,
        drivy_fee: @rental.drivy_fee,
      },
    }
  end
end
