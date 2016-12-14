class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :order_number
      t.string :status
      t.integer :tranx_amount

      t.timestamps
    end
  end
end
