require 'rails_helper'

feature 'Visitor visits home page' do
  context 'and search for promotion' do
    scenario 'successfully' do
      creator = User.create!(email: 'cris@mail.com', password: '123456')
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033', user: creator)
      Promotion.create!(name: 'Ano Novo', description: 'Promoção de Ano Novo',
                        code: 'ANONOVO10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033', user: creator) 
      Promotion.create!(name: 'Carnaval', description: 'Desconto de Carnaval',
                        code: 'CARNAVAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033', user: creator)
  
      visit root_path
      fill_in 'Busca:', with: 'Promoção'
      click_on 'Pesquisar'

      expect(current_path).to eq search_path
      expect(page).to have_content('Natal')
      expect(page).to have_content('Promoção de Natal')
      expect(page).to have_content('Ano Novo')
      expect(page).to have_content('Promoção de Ano Novo')
      expect(page).not_to have_content('Carnaval')
    end

    scenario 'without result' do
      creator = User.create!(email: 'cris@mail.com', password: '123456')
      Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033', user: creator)

      visit root_path
      fill_in 'Busca:', with: 'Carnaval'
      click_on 'Pesquisar'

      expect(current_path).to eq search_path
      expect(page).not_to have_content('Natal')
      expect(page).to have_content('Não foram encontrados resultados para a busca')
    end
  end

  context 'and search for coupon' do
    scenario 'successfully' do
      creator = User.create!(email: 'cris@mail.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033', user: creator)
      Coupon.create!(code: 'ABC0001', promotion: promotion)
      Coupon.create!(code: 'ZXW0001', promotion: promotion)
  
      visit root_path
      fill_in 'Busca:', with: 'ABC'
      click_on 'Pesquisar'

      expect(current_path).to eq search_path
      expect(page).to have_content('ABC0001')
      expect(page).not_to have_content('ZXW0001')
    end

    scenario 'and view details' do
      creator = User.create!(email: 'cris@mail.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                        code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                        expiration_date: '22/12/2033', user: creator)
      Coupon.create!(code: 'ABC0001', promotion: promotion, status: :active)
      
      login_as creator
      visit root_path
      fill_in 'Busca:', with: 'ABC'
      click_on 'Pesquisar'
      click_on 'ABC0001'

      expect(current_path).to eq promotion_path(promotion)
      expect(page).to have_content('Ativo')
    end

    scenario 'without result' do
      creator = User.create!(email: 'cris@mail.com', password: '123456')
      promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                    expiration_date: '22/12/2033', user: creator)
      Coupon.create!(code: 'ABC0001', promotion: promotion)
      Coupon.create!(code: 'ZXW0001', promotion: promotion)

      visit root_path
      fill_in 'Busca:', with: 'DEF'
      click_on 'Pesquisar'

      expect(current_path).to eq search_path
      expect(page).not_to have_content('ABC')
      expect(page).not_to have_content('ZXW')
      expect(page).to have_content('Não foram encontrados resultados para a busca')
    end
  end
end