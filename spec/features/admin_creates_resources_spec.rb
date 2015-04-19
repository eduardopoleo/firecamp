require 'spec_helper'

feature "Admin creates various resources and shares them" do
  scenario "Admin creates post" do
    admin_login
    admin_creates_groups

    click_link('group_1')
    fill_in('Title', with: 'First message')
    fill_in('Content', with: 'Some content lajfk alsfj')
    
    click_button('Post!')

    expect(page).to have_content('First message')

    click_link('Guides')
    fill_in('Title', with: 'First guide')
    fill_in('Description', with: 'A very breif description')
    fill_in('Category', with: 'Drama')
    fill_in('Content', with: 'Some very long contetn')
    click_button('Create Guide!')
    expect(page).to have_content('First guide')
  end
end
