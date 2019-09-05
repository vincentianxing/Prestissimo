class AddTotalCreditsToCarts < ActiveRecord::Migration
  def change
    add_column :carts, :total_credits, :double
  end
end
