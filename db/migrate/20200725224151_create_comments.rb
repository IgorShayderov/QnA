class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :commentable, null: false, polymorphic: true
      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
