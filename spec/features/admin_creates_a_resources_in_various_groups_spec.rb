require 'spec_helper'

feature "Admin creates various resources and shares them" do
  scenario "Admin creates post" do
    admin_login
    admin_creates_groups

    click_link('group_1')
    fill_in('Title', with: 'First message')
    fill_in('Content', with: 'Some content lajfk alsfj')
    
    check('Coffeeco MS')
    check('Coffeeco KC')
    click_button('Post!')

    expect(page).to have_content('First message')
    visit groups_path
    click_link('group_2')
    expect(page).to have_content('First message')
  end

  scenario "Admin creates guides" do
    admin_login
    admin_creates_groups

    click_link('group_1')
    click_link('Guides')
    fill_in('Title', with: 'First Guide')
    fill_in('Content', with: 's lksajf f slajf jf als f')
    
    check('Coffeeco MS')
    check('Coffeeco KC')
    click_button('Create Guide!')

    expect(page).to have_content('First Guide')
    visit groups_path
    click_link('group_2')
    click_link('Guides')
    expect(page).to have_content('First Guide')
  end
end
