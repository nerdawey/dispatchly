class AddNameAndLastLoginAtToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :name, :string
    add_column :users, :last_login_at, :datetime
  end
end
