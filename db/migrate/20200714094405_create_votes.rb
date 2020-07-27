# frozen_string_literal: true

class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :value, null: false, default: 0
      t.references :votable, null: false, polymorphic: true
      t.belongs_to :user, null: false

      t.timestamps
    end
  end
end
