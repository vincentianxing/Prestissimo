class AddTotalCreditsToCarts < ActiveRecord::Migration[3.2]
  def change
    add_column :carts, :total_credits, :double
  end
end
