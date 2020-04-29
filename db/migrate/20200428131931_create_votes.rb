class CreateVotes < ActiveRecord::Migration[6.0]
  def change
    create_table :votes do |t|
      t.integer :score, default: 0, null: false
      t.belongs_to :votable, polymorphic: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
