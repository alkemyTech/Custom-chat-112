class CreateConversationsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.references :user1, null: false, index: true, foreign_key: { to_table: :users }
      t.references :user2, null: false, index: true, foreign_key: { to_table: :users }
      t.string :state
      t.timestamps
    end
  end
end
