# Goodreads

## Software Architecture 2024-20 Group 3

Members:

- Carmencita Avendaño P.
- Nicolás Brito F.
- Victoria Guerriero B.

## How to run the application

The app runs by using Docker. Please make sure docker is installed before attempting to run it. Use the following commands to start the app:

Run Ruby on Rails with MongoDB:

```zsh

   docker-compose up --build
```

Run Ruby on Rails, MongoDB and Redis:

```zsh

   docker-compose -f docker-compose.redis.yml up --build
```

Run Ruby on Rails, MongoDB and ElasticSearch:

```zsh

   docker-compose -f docker-compose.elasticsearch.yml up --build
   docker-compose -f docker-compose.elasticsearch.yml exec web bundle exec rails db:seed

```

Run Ruby on Rails, MongoDB and Reverse Proxy - Envoy:

```zsh

   docker-compose -f docker-compose.proxy.yml up --build
   docker-compose -f docker-compose.proxy.yml exec web bundle exec rails db:seed

```

Run Ruby on Rails, MongoDB, Redis, ElasticSearch and Reverse Proxy - Envoy:

```zsh

   docker-compose -f docker-compose.all.yml up --build
   docker-compose -f docker-compose.all.yml exec web bundle exec rails db:seed

```

## How to check if Envoy Proxy is working

Access the Rails App logs in Docker desktop or with

```zsh
docker-compose logs web
```

If you want to make sure the image has been uploaded check the public directory:

```zsh
docker-compose exec web bash
cd public/uploads
ls -all
```

Also the logs for envoy have to be checked:

```zsh
docker-compose logs envoy
```

In both these logs there are requests for rendering the images.

## How to test redis cache

#### Run in another console:

```zsh
    docker-compose exec web rails console
```

```zsh
   Inside console:

      - To check connections:

         + Rails.cache.write("test_key", "Hello, Redis!")
            - reposne like "OK" if its working
         + Rails.cache.read("test_key")
            - response like "Hello, Redis!"

      - Examples to check cache data if is loaded before:

         + Book.first
         + Rails.cache.write("book/#{book_id}", book)
         + puts cached_book.title
         + Rails.cache.read("books/page/1")
         + Rails.cache.read("authors/page/1")
         + Rails.cache.read("reviews/page/1")
         + Rails.cache.read("sales/page/1")
            - To check if there are saved in the respective page
         + Rails.cache.read("books/total_count")
            - Reponse: e.g. 300
         + Rails.cache.read("authors/total_count")
            - Response: e.g. 50
```
