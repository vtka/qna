class CreateAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :answers do |t|
      t.string :title
      t.string :string
      t.text :body
      t.references :question, null: false, foreign_key: true

      t.timestamps
    end
  end
end
