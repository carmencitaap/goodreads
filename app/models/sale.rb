class Sale
  include Mongoid::Document
  include Mongoid::Timestamps
  field :year, type: Integer
  
  belongs_to :book
end
