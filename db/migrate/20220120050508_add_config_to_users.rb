class AddConfigToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :config, :string
  end
end
