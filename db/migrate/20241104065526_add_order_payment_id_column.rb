class AddOrderPaymentIdColumn < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :payment_id, :integer
    add_column :orders, :status, :string, default: 'initial'

    add_index :orders, [ :payment_id ]
  end
end
