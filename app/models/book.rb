class Book < ApplicationRecord
  belongs_to :category
  validates :author, :title, presence: true, length: { minimum: 3 }
end
