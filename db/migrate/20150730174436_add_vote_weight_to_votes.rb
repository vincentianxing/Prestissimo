class AddVoteWeightToVotes < ActiveRecord::Migration[3.2]
  def change
    add_column :votes, :vote_weight, :integer
  end
end
