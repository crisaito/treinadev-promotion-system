class PaymentMethod #PORO
  attr_reader :name, :code

  def self.all
    payment_methods = []
    json_response.each do |r|
      payment_methods << PaymentMethod.new(name: r[:name], code: r[:code])
    end
    return payment_methods
  end

  def initialize(name:, code:)
    @name = name
    @code = code
  end
end