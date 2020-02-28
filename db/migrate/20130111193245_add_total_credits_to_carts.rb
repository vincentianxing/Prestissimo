class AddTotalCreditsToCarts < ActiveRecord::Migration[4.2]
  def change
    add_column :carts, :total_credits, :double
  end
end
