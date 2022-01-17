class CreateMessagesTable < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :user, null: false, foreign_key: true
      t.string :detail, null: false
      t.boolean :modified, default: false
      t.timestamps
    end
  end
end
