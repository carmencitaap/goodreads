class Book
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :summary, type: String
  field :date_of_publication, type: String
  
  field :cover_image, type: String

  mount_uploader :cover_image, ImageUploader
  
  belongs_to :author
  has_many :reviews
  has_many :sales
end
