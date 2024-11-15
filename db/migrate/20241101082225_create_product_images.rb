class CreateProductImages < ActiveRecord::Migration[7.2]
  def change
    create_table :product_images do |t|
      t.belongs_to :product
      t.integer :weight, default: 0
      # 使用 Active Storage 处理附件
      t.references :image, foreign_key: true
      t.timestamps
    end
  end
end
