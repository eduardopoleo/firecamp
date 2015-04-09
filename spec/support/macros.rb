def login(a_user = nil)
  user = a_user || Fabricate(:user)
  visit root_path
  fill_in 'email', with: user.email
  fill_in 'password', with: user.password
  click_button 'Log In'
end

def admin_login
  rich = Fabricate(:admin, email: 'rich@gmail.com', password: 'password')
  visit root_path
  fill_in('email', with: 'rich@gmail.com' )
  fill_in('password', with: 'password')
  click_button('Log In')
end

def admin_creates_groups
  fill_in('Name', with: 'Coffeeco MS')
  fill_in('Description', with: 'This is a coffee shop located in Kingston Downtown')
  click_button('Create Group')

  fill_in('Name', with: 'Coffeeco KC')
  fill_in('Description', with: 'This is a coffee shop located in Kingston Downtown')
  click_button('Create Group')
end
