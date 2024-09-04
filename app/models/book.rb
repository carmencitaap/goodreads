class Book
  include Mongoid::Document
  include Mongoid::Timestamps
  include OpenSearch::Model
  include OpenSearch::Model::Callbacks

  field :title, type: String
  field :summary, type: String
  field :date_of_publication, type: String
  
  belongs_to :author
  has_many :reviews
  has_many :sales

  settings do
    mappings dynamic: false do
      indexes :title, type: 'text'
      indexes :summary, type: 'text'
    end
  end

  def as_indexed_json(options = {})
    as_json(only: [:title, :summary])
  end
end
