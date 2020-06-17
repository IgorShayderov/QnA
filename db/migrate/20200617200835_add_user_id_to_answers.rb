class AddUserIdToAnswers < ActiveRecord::Migration[6.0]
  def change
    add_column :answers, :user_id, :string, null: false, foreign_key: true
  end
end
