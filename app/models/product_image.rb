class ProductImage < ApplicationRecord
  belongs_to :product
  #  Active Storage:
  has_one_attached :image
end
