class SalesController < ApplicationController
  before_action :set_sale, only: %i[ show edit update destroy ]

  # GET /sales or /sales.json
  def index
    per_page = 10
    page = (params[:page] || 1).to_i
    offset = (page - 1) * per_page

    cache_key = "sales/page/#{page}"

    @total_sales = Rails.cache.fetch("sales/total_count", expires_in: 12.hours) do
      Sale.count
    end

    @sales = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Sale.limit(per_page).offset(offset).to_a
    end
  end

  # GET /sales/1 or /sales/1.json
  def show
    cache_key = "sale/#{params[:id]}"
    @sale = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Sale.find(params[:id])
    end
  end

  # GET /sales/new
  def new
    @sale = Sale.new
  end

  # GET /sales/1/edit
  def edit
  end

  # POST /sales or /sales.json
  def create
    @sale = Sale.new(sale_params)

    respond_to do |format|
      if @sale.save
        clear_sales_cache
        format.html { redirect_to sale_url(@sale), notice: "Sale was successfully created." }
        format.json { render :show, status: :created, location: @sale }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sales/1 or /sales/1.json
  def update
    respond_to do |format|
      if @sale.update(sale_params)
        clear_sales_cache
        format.html { redirect_to sale_url(@sale), notice: "Sale was successfully updated." }
        format.json { render :show, status: :ok, location: @sale }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sale.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sales/1 or /sales/1.json
  def destroy
    @sale.destroy!
    clear_sales_cache

    respond_to do |format|
      format.html { redirect_to sales_url, notice: "Sale was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sale
    cache_key = "sale/#{params[:id]}"
    @sale = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      Sale.find(params[:id])
    end
  end

  # Only allow a list of trusted parameters through.
  def sale_params
    params.require(:sale).permit(:book_id, :year)
  end

  # Clear related cache when sales are created, updated, or deleted.
  def clear_sales_cache
    Rails.cache.delete("sales/total_count")
    Rails.cache.delete_matched("sales/page/*")
  end
end
