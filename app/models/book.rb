class Book
  include Mongoid::Document
  include Mongoid::Timestamps

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  
  field :title, type: String
  field :summary, type: String
  field :date_of_publication, type: String
  
  belongs_to :author
  has_many :reviews
  has_many :sales

  # Optional: Define custom mappings for Elasticsearch
  def as_indexed_json(options = {})
    self.as_json(
      only: [:title, :summary, :date_of_publication],
      include: {
        author: { only: [:name] }, # Assuming the Author model has a name field
        reviews: { only: [:review] }, # Assuming the Review model has a content field
        sales: { only: [:amount] } # Assuming the Sale model has an amount field
      }
    )
  end
end