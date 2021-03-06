require 'rails_helper'

feature 'User sign in' do 
    scenario 'successfully' do
        user = User.create!(email: 'cris@gmail.com', password: '123456')

        visit root_path
        click_on 'Entrar'
        within('form') do
            fill_in 'E-mail', with: user.email
            fill_in 'Senha', with: '123456'
            click_on 'Entrar'
        end

        expect(page).to have_content user.email
        expect(page).to have_content 'Login efetuado com sucesso'
        expect(page).to have_link 'Sair'
        expect(page).not_to have_link 'Entrar'
    end

    scenario 'and logout' do
        user = User.create!(email: 'cris@gmail.com', password: '123456')

        visit root_path
        click_on 'Entrar'
        within('form') do
            fill_in 'E-mail', with: user.email
            fill_in 'Senha', with: '123456'
            click_on 'Entrar'
        end

        click_on 'Sair'

        within('nav') do
            expect(page).not_to have_link 'Sair'
            expect(page).not_to have_content user.email
            expect(page).to have_link 'Entrar'
        end
    end

    scenario 'up successfully' do
        visit root_path
        click_on 'Entrar'
        click_on 'Sign up'    
        fill_in 'E-mail', with: 'cris@gmail.com'
        fill_in 'Senha', with: '123456'
        fill_in 'Confirme sua senha', with: '123456'
        click_on 'Sign up'  
        
        expect(page).to have_content 'Bem vindo! Você realizou seu registro com sucesso.'
        expect(page).to have_content 'cris@gmail.com' 
        expect(page).to have_link 'Sair'
    end
end