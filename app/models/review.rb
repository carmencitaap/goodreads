class Review
  include Mongoid::Document
  include Mongoid::Timestamps
  field :review, type: String
  field :score, type: Integer
  field :upvote, type: Boolean

  RATINGS =[1,2,3,4,5]

  validates :score, inclusion: { in: RATINGS }

  belongs_to :book
end
