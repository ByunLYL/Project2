class AddUserUuidColumn < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :uuid, :string

    add_index :users, [:uuid], unique: true

    User.find_each do |user|
      user.uuid = RandomCode.generate_utoken
      user.save
    end
  end
end
