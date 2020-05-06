class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.text :body, null: false
      t.references :author, foreign_key: { to_table: :users }, null: false
      t.references :commentable, polymorphic: true, null: false, index: true

      t.timestamps
    end
  end
end
