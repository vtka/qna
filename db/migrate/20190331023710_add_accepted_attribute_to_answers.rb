class AddAcceptedAttributeToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :accepted, :boolean, null: false, default: false
  end
end
