require 'spec_helper'

feature "Admin invites other users" do
  scenario "with valid user and payment info" do
    admin_login
    admin_creates_groups

    fill_in('Email', with: 'john@gmail.com')
    check('Coffeeco MS')
    click_button('Send Invitation')
    click_link('Log Out')

    open_email('john@gmail.com')
    current_email.click_link('Join Us!')

    fill_in('user_password', with: 'password')
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
