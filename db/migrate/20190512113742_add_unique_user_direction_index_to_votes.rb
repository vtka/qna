class AddUniqueUserDirectionIndexToVotes < ActiveRecord::Migration[5.2]
  def change
    add_index :votes, %i[user_id votable_type votable_id], unique: true
  end
end
