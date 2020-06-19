class AddUserIdToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :user_id, :integer, null: false, foreign_key: true
  end
end
