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
end