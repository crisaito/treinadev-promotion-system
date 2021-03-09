require 'rails_helper'

describe 'Coupon management' do
  context 'GET coupon' do
    it 'should render coupon information' do
      #Arrange
      user = User.create!(email: 'cris@mail.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033', user: user)
      promotion.generate_coupons!
      coupon = promotion.coupons.last 

      #Act
      get "/api/v1/coupons/#{coupon.code}"

      #Assert
      json_response = JSON.parse(response.body, symbolize_names: true)
      #{code: 'NATAL10', valor: '10'} =>  json_response[:code], json_response[:valor]
      expect(response).to have_http_status(200)
      expect(json_response[:status]).to eq('active')
      expect(json_response[:promotion][:discount_rate]).to eq('10.0')
      expect(json_response[:code]).to eq(coupon.code)
    end

    it 'should return 404 if coupon code does not exist' do
      get  '/api/v1/coupons/blabla'

      expect(response).to have_http_status :not_found
    end
  end
end