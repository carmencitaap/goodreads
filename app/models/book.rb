class Book
  include Mongoid::Document
  include Mongoid::Timestamps
  field :title, type: String
  field :summary, type: String
  field :date_of_publication, type: String
  
  belongs_to :author
end
