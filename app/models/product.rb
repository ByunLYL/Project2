class Product < ApplicationRecord

  validates :category_id, presence: { message: "The category cannot be empty" }
  validates :title, presence: { message: "The name cannot be empty" }
  validates :status, inclusion: { in: %w[on off],
    message: "Item status must beon | off" }
  validates :amount, numericality: { only_integer: true,
    message: "Inventory must be an integer" },
    if: proc { |product| !product.amount.blank? }
  validates :amount, presence: { message: "The inventory cannot be empty" }
  validates :msrp, presence: { message: "MSRPcan not be empty" }
  validates :msrp, numericality: { message: "MSRP Must be a number" },
    if: proc { |product| !product.msrp.blank? }
  validates :price, numericality: { message: "The price must be a figure" },
    if: proc { |product| !product.price.blank? }
  validates :price, presence: { message: "The price cannot be empty" }
  validates :description, presence: { message: "The description cannot be empty" }

  belongs_to :category
  has_many :product_images, -> { order(weight: 'desc') },
    dependent: :destroy
  has_one :main_product_image, -> { order(weight: 'desc') },
    class_name: :ProductImage

  before_create :set_default_attrs

  scope :onshelf, -> { where(status: Status::On) }

  module Status
    On = 'on'
    Off = 'off'
  end

  private
  def set_default_attrs
    self.uuid = RandomCode.generate_product_uuid
  end
end
