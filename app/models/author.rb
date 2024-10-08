class Author
  include Mongoid::Document
  include Mongoid::Timestamps
  field :name, type: String
  field :date_of_birth, type: Date
  field :country_of_origin, type: String
  field :short_description, type: String

  field :image, type: String

  mount_uploader :image, ImageUploader

  has_many :books, dependent: :destroy

  def store_dir
    "authors/#{name.parameterize}/images"
  end
end
