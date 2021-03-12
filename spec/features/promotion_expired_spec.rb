require 'rails_helper'

feature 'promotion expired' do
  scenario 'date expired eq date' do
    user = User.create!(email: 'crist@mail.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
      expiration_date: '22/12/2021', user: user)
    
    travel_to(Date.new(2023, 10, 10))
    login_as user
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'

    expect(page).to have_content('Esta promoção está expirada')
    expect(page).to have_content('Status: Expirado')
    expect(page).not_to have_link('Aprovar Promoção')
  end

  scenario 'and inactivate cupons' do
    user = User.create!(email: 'crist@mail.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
      code: 'NATAL10', discount_rate: 10, coupon_quantity: 2,
      expiration_date: '22/12/2021', user: user)
    first_coupon = Coupon.create!(code: 'ABC0001', promotion: promotion)
    second_coupon = Coupon.create!(code: 'ABC0002', promotion: promotion)
    
    travel_to(Date.new(2023, 10, 10))

    login_as user
    visit root_path
    click_on 'Promoções'
    click_on 'Natal'

    expect(page).to have_content('ABC0001 (Inativo)')
    expect(page).to have_content('ABC0002 (Inativo)')
  end
end