# Goodreads

## Software Architecture 2024-20 Group 3

Members:

- Carmencita Avendaño P.
- Nicolás Brito F.
- Victoria Guerriero B.

## Application

This is a Goodreads like application, where you can make a review for a specific book. It has the following schema:

1. Authors:

   - name (INT)
   - date_of_birth (DATE)
   - country_of_origin (CHAR)
   - short_description (CHAR)

2. Books:

   - title (CHAR)
   - summary (CHAR)
   - date_of_publication (DATE)
   - author_id (CHAR)

3. Reviews:

   - review (CHAR)
   - score (INT)
   - upvote (BOOL)
   - book_id (CHAR)

4. Sales:
   - book_id (CHAR)
   - year (INT)

## Architecture

This app is developed with the framework [Ruby on Rails](https://rubyonrails.org/), with a [MongoDB](https://www.mongodb.com/) database.

## How to run the application

The app runs by using Docker. Please make sure docker is installed before attempting to run it. Use the following commands to start the app:

```zsh
Run Ruby on Rails with MongoDB:

   docker-compose up --build
```

```zsh
Run Ruby on Rails, MongoDB and Redis:

   docker-compose -f docker-compose.redis.yml up --build
```

```zsh
Run Ruby on Rails, MongoDB and ElasticSearch:

   docker-compose -f docker-compose.elasticsearch.yml up --build
   docker-compose -f docker-compose.elasticsearch.yml exec web bundle exec rails db:seed

```

```zsh
Run Ruby on Rails, MongoDB and Reverse Proxy - Envoy:

   XXX
```

```zsh
Run Ruby on Rails, MongoDB, Redis, ElasticSearch and Reverse Proxy - Envoy:

   XXX
```

## How to test redis cache:

### Run in another console:

    docker-compose exec web rails console

--

      Inside console:

      - To check connections:

         - Rails.cache.write("test_key", "Hello, Redis!")
            - reposne like "OK" if its working

         - Rails.cache.read("test_key")
            - response like "Hello, Redis!"

      - To check the data of cache:

         - Book.first
         - Rails.cache.write("book/#{book_id}", book)
         - puts cached_book.title
         - Rails.cache.read("books/page/1")
         - Rails.cache.read("authors/page/1")
         - Rails.cache.read("reviews/page/1")
         - Rails.cache.read("sales/page/1")
            - To check if there are saved in the respective page
         - Rails.cache.read("books/total_count")
            - Reponse: 300
         - Rails.cache.read("authors/total_count")
            - Response: 50
