Fabricator(:user) do
  email {Faker::Internet.email} 
  full_name {Faker::Name.name}
  password {Faker::Internet.password}
  token {SecureRandom.urlsafe_base64}
end
