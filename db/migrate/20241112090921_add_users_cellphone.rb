class AddUsersCellphone < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :cellphone, :string

    remove_index :users, [:email]
    add_index :users, [:email]
    add_index :users, [:cellphone]

    change_column :users, :email, :string, null: true
  end
end
