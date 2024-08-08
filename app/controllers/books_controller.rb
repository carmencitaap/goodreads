class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    #@books = Book.all
    per_page = 10
    page = (params[:page] || 1).to_i
    offset = (page - 1) * per_page

    @total_books = Book.count
    @books = Book.limit(per_page).offset(offset)
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1 or /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to book_url(@book), notice: "Book was successfully updated." }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1 or /books/1.json
  def destroy
    @book.destroy!

    respond_to do |format|
      format.html { redirect_to books_url, notice: "Book was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def top_10_rated_books
    @top_books = Book.collection.aggregate([
      {
        '$lookup': {
          'from': 'reviews',
          'localField': '_id',
          'foreignField': 'book_id',
          'as': 'reviews'
        }
      },
      {
        "$unwind": "$reviews"
      },
      {
        '$lookup': {
          'from': 'authors',
          'localField': 'author_id',
          'foreignField': '_id',
          'as': 'author'
        }
      },
      {
        "$unwind": "$author"
      },
      {
        "$group": {
          _id: '$_id',
          title: { "$first": '$title' },
          summary: { "$first": '$summary' },
          date_of_publication: { "$first": '$date_of_publication' },
          author_name: { "$first": '$author.name' },
          average_score: { "$avg": '$reviews.score' }
        }
      },
      {
        "$sort": { average_score: -1 }
      },
      {
        "$limit": 10
      }
    ])
  
    respond_to do |format|
      format.html 
      format.json { render json: @top_books }
    end
  end

  def top_50_selling_books
    book_sales = Book.collection.aggregate([
      {
        '$lookup': {
          'from': 'sales',
          'localField': '_id',
          'foreignField': 'book_id',
          'as': 'sales'
        }
      },
      {
        "$unwind": "$sales"
      },
      {
        "$group": {
          _id: '$_id',
          title: { "$first": '$title' },
          summary: { "$first": '$summary' },
          date_of_publication: { "$first": '$date_of_publication' },
          author_id: { "$first": '$author_id' },
          total_sales: { "$sum": 1 } 
        }
      }
    ])
  
    author_sales = Author.collection.aggregate([
      {
        '$lookup': {
          'from': 'books',
          'localField': '_id',
          'foreignField': 'author_id',
          'as': 'books'
        }
      },
      {
        "$unwind": "$books"
      },
      {
        '$lookup': {
          'from': 'sales',
          'localField': 'books._id',
          'foreignField': 'book_id',
          'as': 'sales'
        }
      },
      {
        "$unwind": "$sales"
      },
      {
        "$group": {
          _id: '$_id',
          name: { "$first": '$name' },
          total_author_sales: { "$sum": 1 }
        }
      }
    ])

    top_books_by_year = Book.collection.aggregate([
      {
        '$lookup': {
          'from': 'sales',
          'localField': '_id',
          'foreignField': 'book_id',
          'as': 'sales'
        }
      },
      {
        "$unwind": "$sales"
      },
      {
        "$addFields": {
          "date_of_publication": {
            "$toDate": "$date_of_publication"
          }
        }
      },
      {
        "$group": {
          _id: {
            year: "$sales.year", 
            book_id: '$_id'
          },
          total_sales: { "$sum": 1 } 
        }
      },
      {
        "$sort": { 'total_sales': -1 }
      },
      {
        "$group": {
          _id: '$_id.year',
          books: {
            "$push": {
              book_id: '$_id.book_id',
              total_sales: '$total_sales'
            }
          }
        }
      },
      {
        "$project": {
          year: '$_id',
          top_books: { "$slice": ['$books', 5] }
        }
      }
    ])
  
    author_sales_hash = author_sales.reduce({}) do |hash, author|
      hash[author['_id']] = author['total_author_sales']
      hash
    end
  
    top_books_by_year_hash = top_books_by_year.reduce({}) do |hash, year_data|
      year_data['top_books'].each do |book_data|
        hash[book_data['book_id']] ||= []
        hash[book_data['book_id']] << year_data['year']
      end
      hash
    end
  
    @top_books = book_sales.map do |book|
      author = Author.collection.find(_id: book['author_id']).first
      publication_year = Date.parse(book['date_of_publication']).year
      {
        id: book['_id'],
        title: book['title'],
        summary: book['summary'],
        date_of_publication: book['date_of_publication'],
        author_id: book['author_id'],
        author_name: author['name'],
        total_sales: book['total_sales'],
        total_author_sales: author_sales_hash[book['author_id']],
        top_5_in_year: top_books_by_year_hash[book['_id']]&.include?(publication_year)
      }
    end.sort_by { |book| -book[:total_sales] }.first(50)
  
    respond_to do |format|
      format.html
      format.json { render json: @top_books }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_book
    @book = Book.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def book_params
    params.require(:book).permit(:title, :date_of_publication, :summary, :author_id)
  end
end
