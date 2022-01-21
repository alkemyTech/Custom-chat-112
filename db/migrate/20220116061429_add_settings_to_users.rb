class AddSettingsToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :settings, :string
  end
end
