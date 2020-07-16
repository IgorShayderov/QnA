class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :count, null: false, default: 0
      t.string :votable_type, null: false
      t.integer :votable_id, null: false
      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
