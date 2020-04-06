class RemoveTitleColumnFromAnswers < ActiveRecord::Migration[6.0]
  def change
    remove_column :answers, :title, :string
  end
end
