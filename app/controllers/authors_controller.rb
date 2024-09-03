class AuthorsController < ApplicationController
  before_action :set_author, only: %i[ show edit update destroy ]

  def index
    per_page = 10
    page = (params[:page] || 1).to_i
    offset = (page - 1) * per_page

    @total_authors = Author.count
    @authors = Author.limit(per_page).offset(offset)
  end

  def show
  end

  def new
    @author = Author.new
  end

  def edit
  end

  def create
    @author = Author.new(author_params)

    respond_to do |format|
      if @author.save
        format.html { redirect_to author_url(@author), notice: "Author was successfully created." }
        format.json { render :show, status: :created, location: @author }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @author.update(author_params)
        format.html { redirect_to author_url(@author), notice: "Author was successfully updated." }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @author.destroy!

    respond_to do |format|
      format.html { redirect_to authors_url, notice: "Author was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def authors_stats
    @stats = Author.collection.aggregate([
      {
        '$lookup': {
          'from': 'books',
          'localField': '_id',
          'foreignField': 'author_id',
          'as': 'books'
        }
      },
      {
        '$lookup': {
          'from': 'reviews',
          'localField': 'books._id',
          'foreignField': 'book_id',
          'as': 'reviews'
        }
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
        '$project': {
          'name': 1,
          'number_of_books': {
            '$size': '$books'
          },
          'average_score': {
            '$avg': '$reviews.score'
          },
          'total_sales': {
            '$size': '$sales'
          }
        }
      }
    ])
  
  end


  private
    def set_author
      @author = Author.find(params[:id])
    end

    def author_params
      params.require(:author).permit(:name, :date_of_birth, :country_of_origin, :short_description, :image)
    end
end
