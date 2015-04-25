require 'spec_helper'

feature "User sign up", :vcr do
  scenario "with valid user and payment info", :js => true do
    visit new_user_path
    fill_in_user_info('john@gmail.com')
    fill_in_payment_info('4242424242424242')
    click_button('Join Us!')
    expect(page).to have_content('Welcome to Firecamp!') 
    click_link('session-button')
    click_link('Log Out')
  end

  scenario "with invalid user info", :js => true do
    visit new_user_path
    fill_in_user_info("")
    fill_in_payment_info('4242424242424242')
    click_button('Join Us!')
    expect(page).to have_content("can't be blank") 
  end

  scenario "with no credit card", :js => true do
    visit new_user_path
    fill_in_user_info("john@gmail.com")
    fill_in_payment_info('')
    click_button('Join Us!')
    expect(page).to have_content("This card number looks invalid.") 
  end

  scenario "with declined credit card", :js => true do
    visit new_user_path
    fill_in_user_info("john@gmail.com")
    fill_in_payment_info('4000000000000002')
    click_button('Join Us!')
    expect(page).to have_content("Your card was declined.") 
  end

  def fill_in_user_info(email)
    fill_in('Email', with: email)
    fill_in('Full name', with: 'John Strafford')
    fill_in('Password', with: 'password')
  end

  def fill_in_payment_info(card_number)
    fill_in("Credit Card Number", with: card_number)
    fill_in("Security Code", with: '123')
    select('1 - January', from: "date_month")
    select('2017', from: "date_year")
  end
end

