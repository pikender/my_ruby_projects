require "spec_helper"

describe Gtpay do

  describe 'api_endpoint' do 
    context 'default api_endpoint' do
      before do
       Gtpay.configure do |c|
       end
      end

      it { expect(Gtpay.api_endpoint).to eq('https://ibank.gtbank.com') }
    end

    context 'api_endpoint specified' do
      before do
        Gtpay.configure do |c|
          c.api_endpoint = 'abc'
        end
      end
      it { expect(Gtpay.api_endpoint).to eq('abc') }
    end
  end

  describe 'requery_url' do 
    context 'default requery_url' do
      before do
        Gtpay.configure do |c|
          c.api_endpoint = nil
        end
      end
      it { expect(Gtpay.requery_url).to eq('https://ibank.gtbank.com/GTPayService/gettransactionstatus.json') }
    end

    context 'requery_url specified' do
      before do
        Gtpay.configure do |c|
          c.requery_url = 'abc'
        end
      end
      it { expect(Gtpay.requery_url).to eq('abc') }
    end
  end

  describe 'requery' do
    before do
      Gtpay.configure do |c|
        c.gtpay_merc_id = '2606'
        c.gtpay_hash_key = '12345dth'
      end

      @transaction_id = SecureRandom.hex(6)
      @amount = 20000
      @params = {
        tranxid: @transaction_id,
        mertid: Gtpay::gtpay_merc_id,
        amount: @amount,
        hash: Digest::SHA512.hexdigest("#{ Gtpay::gtpay_merc_id }#{ @transaction_id }#{ Gtpay::gtpay_hash_key }")
      }
      @request = Object.new
      @request.stub!(:send_request)
      Gtpay::Request.stub!(:new).with(:get, Gtpay.requery_url, @params).and_return(@request)
    end

    it 'should create a new request object' do
      Gtpay::Request.should_receive(:new).with(:get, 'abc', @params)
      Gtpay.requery(@transaction_id, @amount)
    end

    it 'should send new request' do
      @request.should_receive(:send_request)
      Gtpay.requery(@transaction_id, @amount)
    end
  end

  describe 'request_params' do
    before do
      @transaction_id = SecureRandom.hex(6)
      @amount = 20000
      @params = {
        tranxid: @transaction_id,
        mertid: Gtpay::gtpay_merc_id,
        amount: @amount,
        hash: Digest::SHA512.hexdigest("#{ Gtpay::gtpay_merc_id }#{ @transaction_id }#{ Gtpay::gtpay_hash_key }")
      }
    end

    it { expect(Gtpay.request_params(@transaction_id, @amount)).to eq(@params)}
  end
end
