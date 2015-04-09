require 'spec_helper'

feature "User sign up" do
  scenario "with valid user and payment info" do
    john = Fabricate(:admin, email: 'rich@gmail.com', password: 'password')
    visit root_path
    fill_in('email', with: 'rich@gmail.com' )
    fill_in('password', with: 'password')
    click_button('Log In')

    fill_in('Name', with: 'Coffeeco MS')
    fill_in('Description', with: 'This is a coffee shop located in Kingston Downtown')
    click_button('Create Group')

    #Create group stays in the same page
    fill_in('Name', with: 'Coffeeco KC')
    fill_in('Description', with: 'This is a coffee shop located in Kingston Downtown')
    click_button('Create Group')

    click_link('Create Invitation')
    fill_in('Email', with: 'john@gmail.com')
    check('Coffeeco MS')
    click_button('Send Invitation')
    
    open_email('john@gmail.com')
    current_email.click_link('Join Us!')


    fill_in('Password', with: 'password')
    fill_in('Full name', with: 'John Foster')
    click_button('Sign Up!')
    expect(page).to have_content('MS')
    expect(page).not_to have_content('KC')
    click_link('Log Out')

    fill_in('email', with: 'rich@gmail.com' )
    fill_in('password', with: 'password')
    click_button('Log In')
    expect(page).to have_content('MS')
    expect(page).to have_content('KC')
  end
end
