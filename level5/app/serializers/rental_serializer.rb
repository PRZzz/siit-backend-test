class RentalSerializer
  def initialize(rental)
    @rental = rental
  end

  def as_json
    {
      id: @rental.id,
      options: @rental.options,
      actions: [
        serialize_action('driver', 'debit', @rental.total_price),
        serialize_action('owner', 'credit', @rental.price_due_to_owner),
        serialize_action('insurance', 'credit', @rental.insurance_fee),
        serialize_action('assistance', 'credit', @rental.assistance_fee),
        serialize_action('drivy', 'credit', @rental.drivy_fee),
      ],
    }
  end

  private

  def serialize_action(who, type, amount)
    {
      who: who,
      type: type,
      amount: amount,
    }
  end
end
