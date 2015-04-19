Fabricator(:post) do
  title {Faker::Lorem.sentence} 
  content {Faker::Lorem.paragraph}
  group 
  user
end
