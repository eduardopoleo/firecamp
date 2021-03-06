require 'spec_helper'

feature "User sign up" do
  scenario "with valid user and payment info" do
    john = Fabricate(:user, email: 'john@gmail.com', password: 'password', full_name: 'John Modales')
    visit root_path
    click_link('Forgot Password?')
    fill_in('user_email', with: 'john@gmail.com')
    click_button('Send Email')

    open_email(john.email)
    current_email.click_link('Reset My Password')
    expect(page).to have_content('New Password')


    fill_in('new_password', with: 'newpassword')
    click_button('Reset Password')

    fill_in 'email', with: 'john@gmail.com' 
    fill_in 'password', with: 'newpassword' 
    click_button 'Log In'
    expect(page).to have_content('You have successfully logged in!')
    click_link('Log Out')
  end
end
