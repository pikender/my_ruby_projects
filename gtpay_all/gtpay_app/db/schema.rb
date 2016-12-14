# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20141109150008) do

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

  create_table "orders", :force => true do |t|
    t.string   "order_number"
    t.string   "status"
    t.integer  "tranx_amount"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
