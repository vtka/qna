class CreateAwards < ActiveRecord::Migration[5.2]
  def change
    create_table :awards do |t|
      t.string :title, null: false
      t.references :question, foreign_key: true, index: { unique: true }, null: false
      t.references :recipient, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
