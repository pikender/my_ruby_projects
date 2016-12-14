require 'spec_helper'

module Gtpay
  describe Response do
    context 'gtpay initial response' do
      before do
        @response = {
          "gtpay_tranx_id" => "4f331c9ea713",
          "gtpay_tranx_status_code" => "00",
          "gtpay_tranx_curr" => "NGN",
          "gtpay_tranx_status_msg" => "Approved by Financial Institution",
          "gtpay_gway_name" => "webpay",
          "gtpay_tranx_amt_small_denom" => "3000"
        }
        @response_obj = Gtpay::Response.new(@response)
      end

      it { expect(@response_obj.tranx_id).to eq(@response['gtpay_tranx_id']) }
      it { expect(@response_obj.code).to eq(@response['gtpay_tranx_status_code']) }
      it { expect(@response_obj.message).to eq(@response['gtpay_tranx_status_msg']) }
      it { expect(@response_obj.gateway).to eq(@response['gtpay_gway_name']) }
      it { expect(@response_obj.amount).to eq(@response['gtpay_tranx_amt_small_denom'].to_f) }
      it { expect(@response_obj.currency).to eq(@response['gtpay_tranx_curr']) }
    end

    context 'gtpay requery response' do
      before do
        @response = {
          "Amount" => "3000",
          "MerchantReference" => "FBN|WEB|WEBP|10-10-2014|025679",
          "MertID" => "2606",
          "ResponseCode" => "00",
          "ResponseDescription" => "Approved by Financial Institution"
        }
        @response_obj = Gtpay::Response.new(@response)
      end

      it { expect(@response_obj.code).to eq(@response['ResponseCode']) }
      it { expect(@response_obj.message).to eq(@response['ResponseDescription']) }
      it { expect(@response_obj.amount).to eq(@response['Amount'].to_f) }
      it { expect(@response_obj.merchant_ref).to eq(@response['MerchantReference']) }
    end

    describe 'success?' do
      context 'true' do
        before do
          @response = {
            'ResponseCode' => '00'
          }
          @response_obj = Gtpay::Response.new(@response)
        end
        it { expect(@response_obj.success?).to be_true }
      end
      context 'true' do
        before do
          @response = {
            'ResponseCode' => 'invalid'
          }
          @response_obj = Gtpay::Response.new(@response)
        end
        it { expect(@response_obj.success?).to be_false }
      end
    end

    describe 'ok?' do
      context 'true' do
        before do
          @response = Hash.new
          @response.stub!(:code).and_return(200)
          @response_obj = Gtpay::Response.new(@response)
        end
        it { expect(@response_obj.ok?).to be_true }
      end
      context 'true' do
        before do
          @response = Hash.new
          @response.stub!(:code).and_return(400)
          @response_obj = Gtpay::Response.new(@response)
        end
        it { expect(@response_obj.ok?).to be_false }
      end
    end

    describe 'amount_matches?' do
      before do
        @response = {
          'Amount' => '200.0'
        }
      end
      context 'true' do
        before do
          @response_obj = Gtpay::Response.new(@response)
        end
        it { expect(@response_obj.amount_matches?(200.0)).to be_true }
      end
      context 'true' do
        before do
          @response_obj = Gtpay::Response.new(@response)
        end
        it { expect(@response_obj.amount_matches?(300.6)).to be_false }
      end
    end
  end
end