class ReviewsController < ApplicationController
  before_action :set_review, only: %i[show edit update destroy]

  # GET /reviews or /reviews.json
  def index
    per_page = 10
    @current_page = params[:page].to_i > 0 ? params[:page].to_i : 1

    # Cache the paginated reviews list
    cache_key = "reviews/page/#{@current_page}"
    @reviews = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Review.limit(per_page).offset((@current_page - 1) * per_page).to_a
    end

    @total_reviews = Rails.cache.fetch("reviews/total_count", expires_in: 12.hours) do
      Review.count
    end
  end

  # GET /reviews/1 or /reviews/1.json
  def show
    # Cache individual review
    cache_key = "review/#{params[:id]}"
    @review = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Review.find(params[:id])
    end
  end

  # GET /reviews/new
  def new
    @review = Review.new
  end

  # GET /reviews/1/edit
  def edit
  end

  # POST /reviews or /reviews.json
  def create
    @review = Review.new(review_params)

    respond_to do |format|
      if @review.save
        # Purge related caches
        purge_cache

        format.html { redirect_to review_url(@review), notice: "Review was successfully created." }
        format.json { render :show, status: :created, location: @review }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reviews/1 or /reviews/1.json
  def update
    respond_to do |format|
      if @review.update(review_params)
        # Purge related caches
        purge_cache

        format.html { redirect_to review_url(@review), notice: "Review was successfully updated." }
        format.json { render :show, status: :ok, location: @review }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @review.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reviews/1 or /reviews/1.json
  def destroy
    @review.destroy!

    # Purge related caches
    purge_cache

    respond_to do |format|
      format.html { redirect_to reviews_url, notice: "Review was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_review
    # Use the cache if available
    cache_key = "review/#{params[:id]}"
    @review = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Review.find(params[:id])
    end
  end

  # Only allow a list of trusted parameters through.
  def review_params
    params.require(:review).permit(:review, :upvote, :book_id, :score)
  end

  # Purge related caches when data is modified
  def purge_cache
    Rails.cache.delete("review/#{@review.id}")
    Rails.cache.delete("reviews/total_count")
    
    total_pages = (Rails.cache.fetch("reviews/total_count") { Review.count } / 10.0).ceil
    (1..total_pages).each do |page|
      Rails.cache.delete("reviews/page/#{page}")
    end
  end
end
