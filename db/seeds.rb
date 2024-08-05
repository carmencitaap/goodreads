

def random_date(start_year, end_year)
  start_date = Date.new(start_year, 1, 1)
  end_date = Date.new(end_year, 12, 31)
  (start_date + rand((end_date - start_date).to_i)).strftime('%Y-%m-%d')
end

# Limpia las colecciones
Author.delete_all
Book.delete_all
Review.delete_all
Sale.delete_all

puts 'cleaned db'
# Genera autores
authors = []
50.times do
  author = Author.create!(
    name: Faker::Name.name,
    date_of_birth: random_date(1950, 2000),
    country_of_origin: Faker::Address.country,
    short_description: Faker::Lorem.sentence
  )
  authors << author
end

# Genera libros
books = []
300.times do
  book = Book.create!(
    title: Faker::Book.title,
    summary: Faker::Lorem.paragraph,
    date_of_publication: random_date(1950, 2023),
    author_id: authors.sample.id
  )
  books << book
end

# Genera reseñas
books.each do |book|
  4.times do
    Review.create!(
      review: Faker::Lorem.sentence,
      score: rand(1..5),
      upvote: [true, false].sample,
      book_id: book.id
    )
  end
end

# Genera ventas
years = (2019..2023).to_a
books.each do |book|
  years.each do |year|
    Sale.create!(
      book_id: book.id,
      year: year
    )
  end
end

puts "Data has been successfully inserted into the MongoDB database."