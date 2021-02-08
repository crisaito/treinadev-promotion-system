require 'rails_helper'

feature 'Admin inactivate coupon' do
    scenario 'sucessfully' do
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                      expiration_date: '22/12/2033')
        coupon = Coupon.create!(code: 'ABC0001', promotion: promotion)

        visit root_path
        click_on 'Promoções'
        click_on promotion.name
        click_on 'Inativar'

        coupon.reload
        expect(page).to have_content('ABC0001 (Inativo)')
        expect(coupon).to be_inactive
    end
end