require 'rails_helper'

feature 'Admin generates coupons' do
    scenario 'of a promotion' do
        user = User.create!(email: 'cris@mail.com', password: '123456')
        other_user = User.create!(email: 'tomi@mail.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                          code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                          expiration_date: '22/12/2033', user: user)
        promotion.approve!(other_user)
        promotion.reload
        
        login_as other_user
        visit root_path
        click_on 'Promoções'
        click_on promotion.name
        click_on 'Gerar cupons'

        expect(current_path).to eq(promotion_path(promotion))
        expect(page).to have_content('Cupons gerados com sucesso')
        expect(page).to have_content('NATAL10-0001')
        expect(page).to have_content('NATAL10-0100')
        expect(page).not_to have_content('NATAL10-0101')
    end

    scenario 'hide button if promotion is not approved yet' do
        user = User.create!(email: 'cris@mail.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                          code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                          expiration_date: '22/12/2033', user: user)

        login_as user
        visit promotion_path(promotion)
                          
        expect(promotion.approved?).to be_falsy
        expect(page).not_to have_link('Gerar cupons')
    end

    scenario 'hide button if coupons generated' do
        user = User.create!(email: 'cris@mail.com', password: '123456')
        other_user = User.create!(email: 'tomi@mail.com', password: '123456')
        promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                          code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                          expiration_date: '22/12/2033', user: user)
        promotion.approve!(other_user)
        promotion.reload
        
        login_as other_user
        visit promotion_path(promotion)
        click_on 'Gerar cupons'

        expect(promotion.approved?).to be_truthy
        expect(page).not_to have_link('Gerar cupons')
    end
end