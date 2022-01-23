class CreateConversationsTable < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.string :state
      t.timestamps
    end
  end
end
