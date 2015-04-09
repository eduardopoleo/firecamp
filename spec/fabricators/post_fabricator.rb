Fabricator(:post) do
  title {Faker::Lorem.sentence} 
  content {Faker::Lorem.paragraph}
  user
  groups {[Fabricate(:group)]}
end

