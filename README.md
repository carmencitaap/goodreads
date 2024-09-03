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
how to run the app with the populate and redis:

        docker-compose up --build
```

Redis (REmote DIctionary Server) is an in-memory data structure store that is commonly used as a distributed, in-memory key-value database, cache, and message broker. Here’s a breakdown of its purpose and why it’s widely used:

Caching

Purpose: One of the most common uses of Redis is as a cache to store frequently accessed data temporarily. By caching data, Redis reduces the need to repeatedly access slower back-end databases or perform expensive calculations.
Use Case: In a web application, Redis might cache the results of database queries, HTML fragments, or session data. For example, instead of querying a database every time a user requests a list of products, the application can retrieve this data from Redis, which is much faster.

Summary of Redis Purposes:

- Speed: Provides extremely fast access to data by keeping it in memory.
- Flexibility: Supports a variety of data structures, allowing for diverse use cases.
- Scalability: Enables scaling applications with distributed caching and centralized session storage.
- Real-Time Processing: Supports real-time analytics, pub/sub messaging, and other low-latency operations.
- Resilience: Offers options for persistence to ensure data durability across server restarts.
- Redis is a versatile tool that enhances the performance, scalability, and reliability of applications, especially in environments that demand quick data access and real-time processing.

Invalidate Cache on Create, Update, and Destroy:

Whenever a book is created, updated, or deleted, we'll invalidate the relevant cache entries to ensure the data is fresh.

All the cache data saved have the gets, like all the books for example and the total count, all the CRUD functionalities, in the books, authors, reviews and in the sales. Algo the cache save the top 10 rated books and the top 50 selling books. Also author_stats

How to test redis cache:

docker-compose exec web rails console

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
