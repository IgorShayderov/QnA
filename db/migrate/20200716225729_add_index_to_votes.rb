class AddIndexToVotes < ActiveRecord::Migration[6.0]
  def change
    add_index :votes, %i[votable_id user_id], unique: true
  end
end
