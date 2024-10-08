class Book
  include Mongoid::Document
  include Mongoid::Timestamps

  if ENV['ELASTICSEARCH_URL'].present?
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
  end

  field :title, type: String
  field :summary, type: String
  field :date_of_publication, type: String
  
  field :cover_image, type: String

  mount_uploader :cover_image, ImageUploader
  
  belongs_to :author
  has_many :reviews
  has_many :sales

  def store_dir
    "books/#{title.parameterize}/covers"
  end

  def as_indexed_json(options = {})
    self.as_json(
      only: [:title, :summary, :date_of_publication],
      include: {
        author: { only: [:name] },
        reviews: { only: [:review] },
        sales: { only: [:amount] }
      }
    )
  end

end
