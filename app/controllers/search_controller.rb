# app/controllers/search_controller.rb
class SearchController < ApplicationController
  def index
    if params[:query].present?
      @books = Book.where(:summary => /#{params[:query]}/i)
    else
      @books = []
    end
  end
end
