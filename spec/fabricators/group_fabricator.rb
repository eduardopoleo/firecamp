Fabricator(:group) do
  name {Faker::Lorem.words(4).join(" ")} 
  description {Faker::Lorem.sentence(3)}
  users{[Fabricate(:admin)]} 
end
