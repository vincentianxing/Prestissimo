class AddVoteWeightToVotes < ActiveRecord::Migration[4.2]
  def change
    add_column :votes, :vote_weight, :integer
  end
end
