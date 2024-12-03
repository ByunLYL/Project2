class RemoveImageReferenceFromProductImages < ActiveRecord::Migration[7.2]
  def change
    remove_reference :product_images, :image, foreign_key: true
  end
end
