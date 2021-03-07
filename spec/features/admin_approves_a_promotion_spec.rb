require 'rails_helper'

feature 'Admin approves a promotion' do
  scenario 'successfully' do
    creator = User.create!(email: 'cris@mail.com', password: '123456')
    approval_user = User.create!(email: 'tomi@mail.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: creator)

    login_as approval_user
    visit promotion_path(promotion)
    click_on 'Aprovar Promoção'

    expect(current_path).to eq promotion_path(promotion)
    expect(promotion.approved?).to be_truthy
    expect(promotion.approver).to eq approval_user
    expect(page).to have_content 'Status: Aprovada'
  end

  scenario 'must not be the promotion creator' do
    creator = User.create!(email: 'joao@email.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: creator)

    login_as creator
    visit promotion_path(promotion)

    expect(page).not_to have_link 'Aprovar Promoção'
  end

  scenario 'must be other user' do
    creator = User.create!(email: 'cris@mail.com', password: '123456')
    other_user = User.create!(email: 'tomi@mail.com', password: '123456')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: creator)
    
    login_as other_user
    visit promotion_path(promotion)

    expect(page).to have_link 'Aprovar Promoção'
  end
end