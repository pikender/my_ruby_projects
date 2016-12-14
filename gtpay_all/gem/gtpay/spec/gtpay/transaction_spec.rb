require 'spec_helper'

describe Gtpay::Transaction do

  def new_transaction(params = {})
    Gtpay::Transaction.create!({gtpay_cust_id: 1, gtpay_tranx_amt: 200}.merge(params))
  end
  
  context 'validate_presence_of gtpay_tranx_id' do
    before { subject.stub!(:assign_values).and_return(true) }
    pending { it { should validate_presence_of(:gtpay_tranx_id) } }
  end
  
  pending "Should Matchers dependency" do
    it { should validate_presence_of(:gtpay_cust_id) }
    it { should validate_uniqueness_of(:gtpay_tranx_id) }
    it { should belong_to(:user) }
  end

  pending "Moved to App" do
    it { expect(Gtpay::Transaction::MINIMUM_AMT).to eq(25) }
  end

  it { expect(Gtpay::Transaction::STATUS).to eq({ unsuccessful: 0, successful: 1, pending: 2 }) }

  describe 'table_name' do
    it { expect(Gtpay::Transaction.table_name).to eq('gt_pay_transactions') }
  end

  describe 'assign_values' do
    before :each do
      Gtpay::Transaction.update_all('gtpay_tranx_id = NULL')
      SecureRandom.stub!(:hex).with(6).and_return('abcd1234djl')
      @transaction = new_transaction(gtpay_tranx_amt: 200.367)
    end
      
    it { expect(@transaction.gtpay_tranx_id).to eq('abcd1234djl') }
    
    it { expect(@transaction.gtpay_tranx_amt).to eq(200.37)}

    it { expect(@transaction.status).to eq(Gtpay::Transaction::STATUS[:pending]) }
  end

  describe 'successful?' do
    before do
      @transaction = new_transaction
    end

    context 'true' do
      before { @transaction.update_column(:status, Gtpay::Transaction::STATUS[:successful]) }
      it { expect(@transaction.successful?).to be_true }
    end

    context 'false' do
      before { @transaction.update_column(:status, Gtpay::Transaction::STATUS[:unsuccessful]) }
      it { expect(@transaction.successful?).to be_false }
    end

  end

  describe 'unsuccessful?' do
    before do
      @transaction = new_transaction
    end

    context 'true' do
      before { @transaction.update_column(:status, Gtpay::Transaction::STATUS[:unsuccessful]) }
      it { expect(@transaction.unsuccessful?).to be_true }
    end

    context 'false' do
      before { @transaction.update_column(:status, Gtpay::Transaction::STATUS[:successful]) }
      it { expect(@transaction.unsuccessful?).to be_false }
    end

  end

  describe 'pending?' do
    before do
      @transaction = new_transaction
    end

    context 'true' do
      it { expect(@transaction.pending?).to be_true }
    end

    context 'false' do
      before { @transaction.update_column(:status, Gtpay::Transaction::STATUS[:unsuccessful]) }
      it { expect(@transaction.pending?).to be_false }
    end

  end

  describe 'scope successful' do
    before do
      @successful_transaction = new_transaction
      @successful_transaction.update_column(:status, Gtpay::Transaction::STATUS[:successful])
      @not_successful_transaction = new_transaction
    end

    it { expect(Gtpay::Transaction.successful).to include(@successful_transaction) }

    it { expect(Gtpay::Transaction.successful).not_to include(@not_successful_transaction) }
  end

  describe 'scope unsuccessful' do
    before do
      @unsuccessful_transaction = new_transaction
      @unsuccessful_transaction.update_column(:status, Gtpay::Transaction::STATUS[:unsuccessful])
      @not_unsuccessful_transaction = new_transaction
    end

    it { expect(Gtpay::Transaction.unsuccessful).to include(@unsuccessful_transaction) }

    it { expect(Gtpay::Transaction.unsuccessful).not_to include(@not_unsuccessful_transaction) }
  end

  describe 'scope pending' do
    before do
      @pending_transaction = new_transaction
      @successful_transaction = new_transaction
      @successful_transaction.update_column(:status, Gtpay::Transaction::STATUS[:successful])
    end

    it { expect(Gtpay::Transaction.pending).to include(@pending_transaction) }

    it { expect(Gtpay::Transaction.pending).not_to include(@successful_transaction) }
  end

  describe 'gtpay_tranx_amt_in_cents' do
    before do
      @transaction = new_transaction
    end

    it { expect(@transaction.gtpay_tranx_amt_in_cents).to eq("20000")}
  end

  describe 'update_details' do
    before do
      @transaction = new_transaction
      @response = Object.new
      Gtpay.stub!(:requery).with(@transaction.gtpay_tranx_id, @transaction.gtpay_tranx_amt_in_cents).and_return(@response)
    end
    context 'when status is not pending' do 
      before do
        @transaction.update_column(:status, Gtpay::Transaction::STATUS[:successful])
      end
      it { expect(@transaction.update_details).to be_true }
    end
    context 'when response in successful and amount matches' do
      before do
        @response.stub!(:code).and_return('00')
        @response.stub!(:message).and_return('Approved by financial institution')
        @response.stub!(:gateway).and_return('webpay')
        @response.stub!(:merchant_ref).and_return('merchant_ref')
        @response.stub!(:success?).and_return(true)
        @response.stub!(:amount_matches?).with(@transaction.gtpay_tranx_amt_in_cents).and_return(true)
        @response_hash = { :notice => "Transaction has been confirmed successfully", :status => true }
        @result = @transaction.update_details
      end

      it { expect(@transaction.gtpay_tranx_status_msg).to eq(@response.message) }

      it { expect(@transaction.gtpay_tranx_status_code).to eq(@response.code) }

      it { expect(@transaction.card_type).to eq(@response.gateway) }

      it { expect(@transaction.merchant_ref).to eq(@response.merchant_ref) }

      it { expect(@transaction.status).to eq(Gtpay::Transaction::STATUS[:successful]) }

      it { expect(@result).to be_true }
    end

    context 'when response in successful and amount does not match' do
      before do
        @response.stub!(:code).and_return('00')
        @response.stub!(:message).and_return('Approved by financial institution')
        @response.stub!(:gateway).and_return('webpay')
        @response.stub!(:merchant_ref).and_return('merchant_ref')
        @response.stub!(:success?).and_return(true)
        @response.stub!(:amount_matches?).with(@transaction.gtpay_tranx_amt_in_cents).and_return(false)
        @response_hash = { :error =>  "Transaction was not successful. Reason: Amount Paid is not correct", :status => false }
        @result = @transaction.update_details
      end

      it { expect(@transaction.gtpay_tranx_status_msg).to eq('Amount Paid is not correct') }

      it { expect(@transaction.gtpay_tranx_status_code).to eq(@response.code) }

      it { expect(@transaction.card_type).to eq(@response.gateway) }

      it { expect(@transaction.merchant_ref).to eq(@response.merchant_ref) }

      it { expect(@transaction.status).to eq(Gtpay::Transaction::STATUS[:unsuccessful]) }

      it { expect(@result).to be_true }
    end

    context 'when response in not successful' do
      before do
        @response.stub!(:code).and_return('Z6')
        @response.stub!(:message).and_return('Something wrong')
        @response.stub!(:gateway).and_return('webpay')
        @response.stub!(:merchant_ref).and_return('merchant_ref')
        @response.stub!(:success?).and_return(false)
        @response_hash = { :error =>  "Transaction was not successful. Reason: Something wrong", :status => false }
        @result = @transaction.update_details
      end

      it { expect(@transaction.gtpay_tranx_status_msg).to eq(@response.message) }

      it { expect(@transaction.gtpay_tranx_status_code).to eq(@response.code) }

      it { expect(@transaction.card_type).to eq(@response.gateway) }

      it { expect(@transaction.merchant_ref).to eq(@response.merchant_ref) }

      it { expect(@transaction.status).to eq(Gtpay::Transaction::STATUS[:unsuccessful]) }

      it { expect(@result).to be_true }
    end
  end
end
