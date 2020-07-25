# frozen_string_literal: true

class CreateRewards < ActiveRecord::Migration[6.0]
  def change
    create_table :rewards do |t|
      t.string :name
      t.belongs_to :question, null: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
