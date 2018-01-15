class AddColumnsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :age, :integer
    add_column :users, :password, :string
    add_column :users, :firstname, :string
    add_column :users, :lastname, :string
    add_column :users, :gender, :integer
  end
end
