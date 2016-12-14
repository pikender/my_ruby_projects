class CreateGtpayTransaction < ActiveRecord::Migration # :nodoc:
  def self.up
    create_table "gt_pay_transactions", :force => true do |t|
      t.string   "gtpay_tranx_status_msg"
      t.integer  "gtpay_cust_id"
      t.string   "gtpay_tranx_memo"
      t.string   "gtpay_tranx_status_code"
      t.string   "gtpay_tranx_id"
      t.float    "gtpay_tranx_amt"
      t.string   "gtpay_tranx_curr"
      t.integer  "status"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "order_id"
      t.string   "card_type"
      t.string   "merchant_ref"
    end    
  end

  def self.down
    drop_table :gt_pay_transactions
  end
end