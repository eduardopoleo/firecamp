Fabricator(:guide) do
  title {Faker::Lorem.sentence} 
  description {Faker::Lorem.paragraph}
  content {Faker::Lorem.paragraph(5)}
  category{Faker::Lorem.word}
  admin
  group
end
