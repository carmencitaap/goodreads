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
docker-compose up --build
```


OpenSearch::Model y OpenSearch::Model::Callbacks: Estas inclusiones permiten que el modelo se indexe automáticamente en OpenSearch cuando se crean, actualizan o eliminan documentos.
