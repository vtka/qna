class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :direction, default: 0, null: false
      t.references :votable, polymorphic: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
