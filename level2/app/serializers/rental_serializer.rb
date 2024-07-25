class RentalSerializer
  def initialize(rental)
    @rental = rental
  end

  def as_json
    {
      id: @rental.id,
      price: @rental.price
    }
  end
end
