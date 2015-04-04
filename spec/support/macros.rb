def login(a_user = nil)
  user = a_user || Fabricate(:user)
  visit root_path
  fill_in 'email', with: user.email
  fill_in 'password', with: user.password
  click_button 'Log In'
end
