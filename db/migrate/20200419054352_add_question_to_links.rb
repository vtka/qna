class AddQuestionToLinks < ActiveRecord::Migration[6.0]
  def change
    add_reference :links, :question, null: false, foreign_key: true
  end
end
