require 'rails_helper'

describe PaymentMethod do
  context 'PORO' do
    it 'should initialize a new payment method' do
      pm = PaymentMethod.new(name: 'Cartão de Crédito', code: 'CCRED')

      expect(pm.name).to eq 'Cartão de Crédito'
      expect(pm.code).to eq 'CCRED'
    end
  end
end