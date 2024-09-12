class AuthorsController < ApplicationController
  before_action :set_author, only: %i[ show edit update destroy ]

  # GET /authors or /authors.json
  def index
    per_page = 10
    page = (params[:page] || 1).to_i
    offset = (page - 1) * per_page

    cache_key = "authors/page/#{page}"

    @total_authors = Rails.cache.fetch("authors/total_count", expires_in: 12.hours) do
      Author.count
    end

    @authors = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Author.limit(per_page).offset(offset).to_a
    end
  end

  # GET /authors/1 or /authors/1.json
  def show
    cache_key = "author/#{params[:id]}"
    @author = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Author.find(params[:id])
    end
  end

  # GET /authors/new
  def new
    @author = Author.new
  end

  # GET /authors/1/edit
  def edit
  end

  # POST /authors or /authors.json
  def create
    @author = Author.new(author_params)

    respond_to do |format|
      if @author.save
        clear_authors_cache
        format.html { redirect_to author_url(@author), notice: "Author was successfully created." }
        format.json { render :show, status: :created, location: @author }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /authors/1 or /authors/1.json
  def update
    respond_to do |format|
      if @author.update(author_params)
        clear_authors_cache
        format.html { redirect_to author_url(@author), notice: "Author was successfully updated." }
        format.json { render :show, status: :ok, location: @author }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @author.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authors/1 or /authors/1.json
  def destroy
    @destroyed = @author.destroy!
    clear_authors_cache

    respond_to do |format|
      format.html { redirect_to authors_url, notice: "Author was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def authors_stats
    cache_key = "authors/stats"
    @stats = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Author.collection.aggregate([
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
      ]).to_a
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_author
    cache_key = "author/#{params[:id]}"
    @author = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Author.find(params[:id])
    end
  end

  # Only allow a list of trusted parameters through.
  def author_params
    params.require(:author).permit(:name, :date_of_birth, :country_of_origin, :short_description, :image)
  end

  def clear_authors_cache
    Rails.cache.delete("authors/total_count")
    Rails.cache.delete_matched("authors/page/*")
    Rails.cache.delete("authors/stats")
  end
end
