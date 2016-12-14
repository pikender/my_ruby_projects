require 'spec_helper'

describe GtpayTransactionsController do

  shared_examples_for 'load_cart_for_online_payments' do

    context "when current_cart doesn't exist" do

      before do
        controller.stub!(:current_cart).and_return(nil)
        send_request   
      end

      it 'should redirect to root' do
        expect(response).to redirect_to(root_path)
      end

      it 'should set error message' do
        expect(flash[:error]).to eq("Cart amount should be greater then zero.")
      end

    end

    context 'when cart amount is not valid' do

      before do
        controller.stub!(:current_cart).and_return(@cart)
        @cart.stub!(:tranx_amount).and_return(0)
        send_request
      end

      it 'should redirect to root' do
        expect(response).to redirect_to(root_path)
      end

      it 'should set error message' do
        expect(flash[:error]).to eq("Cart amount should be greater then zero.")
      end

    end

  end

  before do
    @user = mock_model(User)
    # @user.stub!(:inactive?).and_return(false)
    @transaction = mock_model(GtPayTransaction)
    @transactions = [@transaction]
    @order = mock_model(Order)
    @cart = mock_model(Cart)
    controller.stub!(:authenticate_user!).and_return(true)
    controller.stub!(:current_user).and_return(@user)
    @cart.stub!(:order).and_return(@order)
  end

  describe 'index' do

    before do
      get :index
    end

    it 'should redirect to cart' do
      expect(response).to redirect_to(cart_path)
    end

  end

  describe 'create' do

    def send_request(params={})
      post :create, params
    end

    before do
      controller.stub!(:current_cart).and_return(@cart)
      @cart.stub!(:tranx_amount).and_return(1)
      @cart.stub!(:item_removed?)
      controller.stub!(:create_online_order).with('gtpay').and_return(true)
      session[:gtpay_tranx_id] = SecureRandom.hex(6)
      GtPayTransaction.stub!(:new).and_return(@transaction)
      @transaction.stub!(:user=).with(@user)
      @transaction.stub!(:order=).with(@order)
      @transaction.stub!(:save).and_return(true)
    end

    context 'load_cart_for_online_payments' do
      it_behaves_like 'load_cart_for_online_payments'
    end

    context 'when cart item expired' do

      before do
        @cart.stub!(:item_removed?).and_return(true)
        send_request
      end

      it 'should redirect to cart' do
        expect(response).to redirect_to(cart_path)
      end

      it 'should show error message' do
        expect(flash[:error]).to eq("Some items from your cart have expired & order could not be completed.")
      end

    end

    context 'when create_online_order fails' do

      before do
        controller.stub!(:create_online_order).with('gtpay').and_return(false)
        send_request
      end

      it 'should set session checked out' do
        expect(session[:checked_out]).to be_true
      end

      it 'should redirect to cart' do
        expect(response).to redirect_to(cart_path)
      end

      it 'should show error message' do
        expect(flash[:error]).to eq("Cart has errors, order could not be completed")
      end

    end

    it 'should create a new gtpay transaction' do
      GtPayTransaction.should_receive(:new).with(:gtpay_tranx_amt => @cart.tranx_amount, :gtpay_tranx_id => session[:gtpay_tranx_id], :gtpay_tranx_curr => "566").and_return(@transaction)
      send_request(@params)
    end

    it 'should set transaction user' do
      @transaction.should_receive(:user=).with(@user)
      send_request(@params)
    end

    it 'should set transaction order' do
      @transaction.should_receive(:order=).with(@order)
      send_request(@params)
    end

    it 'should set session[:gtpay_tranx_id] to nil' do
      send_request(@params)
      expect(session[:gtpay_tranx_id]).to be_nil
    end

    context 'when transaction saves successfully' do

      it 'should render create template' do
        send_request(@params)
        expect(response).to render_template(:create)
      end
    end

    context 'when transaction save fails' do
      
      before do
        @transaction.stub!(:save).and_return(false)
        send_request(@params)
      end

      it 'should redirect_to payment mode ' do
        expect(response).to redirect_to(payment_mode_path(:permalink => "interswitch"))
      end
    end

  end

  describe 'callback' do
    def send_request(params={})
      post :callback, params
    end

    before do
      @params = { gtpay_tranx_id: @transaction.id.to_s, gtpay_gway_name: 'webpay' }
    end

    context "when gtpay transaction exists" do
      before do
        GtPayTransaction.stub!(:where).with(:gtpay_tranx_id => @params[:gtpay_tranx_id]).and_return(@transactions)
        @response_hash = { error: 'Some error', notice: 'success' }  
        @transaction.stub!(:update_details).and_return(@response_hash)
        @order.stub!(:status_released?).and_return(false)
        @order.stub!(:status_cancelled?).and_return(false)
        @transaction.stub!(:update_column)
        @transaction.stub!(:order).and_return(@order)
        @payment_mode = mock_model(PaymentMode)
        @payment_modes = [@payment_mode]
        PaymentMode.stub!(:where).with(:permalink => 'interswitch').and_return(@payment_modes)
        PaymentMode.stub!(:active).and_return(@payment_modes)
        @payment_modes.stub!(:allowed).with(false).and_return(@payment_modes)
      end

      it "should assign transaction" do
        send_request(@params)
        expect(assigns(:transaction)).to eq(@transaction)
      end

      it "should update transaction details" do
        @transaction.should_receive(:update_details)
        send_request(@params)
      end

      it { send_request(@params); expect(assigns(:order)).to eq(@order)}

      it { send_request(@params); expect(assigns(:gt_pay_response)).to be_true }

      it 'should should find all active payment modes' do
        PaymentMode.should_receive(:active).and_return(@payment_modes)
        @payment_modes.should_receive(:allowed).with(false).and_return(@payment_modes)
        send_request(@params)
      end

      it 'should find payment mode interswitch' do
        PaymentMode.should_receive(:where).with(:permalink => 'interswitch').and_return(@payment_modes)
        send_request(@params)
      end

      it { send_request(@params); expect(assigns(:payment_mode)).to eq(@payment_mode) }

      it { send_request(@params); expect(assigns(:payment_modes)).to eq(@payment_modes)}

      it 'should  render payment_modes show' do
        send_request(@params)
        expect(response).to render_template('/payment_modes/show')
      end


      context 'when transaction update return error' do
        before do
          @response_hash = { error: 'Some error' }
          @transaction.stub!(:update_details).and_return(@response_hash)
          send_request(@params)
        end

        it { expect(assigns(:error)).to eq(@response_hash[:error])}

        it { expect(assigns(:success)).to be_nil }

        it { expect(assigns(:try_other_option)).to eq("Are you having troubles using this payment method? Try our other payment channels") }

      end

      context 'when transaction update return success' do
        before do
          @response_hash = { notice: 'success' }
          @transaction.stub!(:update_details).and_return(@response_hash)
          send_request(@params)
        end

        it { expect(assigns(:success)).to eq(@response_hash[:notice])}

        it { expect(assigns(:error)).to be_nil }

        it { expect(assigns(:try_other_option)).to be_nil }

      end

      context 'when order status released' do
        before do
          @order.stub!(:status_released?).and_return(true)
          send_request(@params)
        end

        it { expect(session[:order_id]).to eq(@order.id) }

        it { expect(response).to redirect_to(complete_order_path(@order))}

        it { expect(flash[:notice]).to eq(@response_hash[:notice])}
      end

      context 'when order status cancelled' do
        before do
          @order.stub!(:status_cancelled?).and_return(true)
          send_request(@params)
        end

        it { expect(session[:checked_out]).to be_true }

        it { expect(response).to redirect_to(carts_path) }

        it { expect(flash[:error]).to eq(@response_hash[:error])}
      end
    end

    context "when gtpay transaction does not exist" do
      before do
        GtPayTransaction.stub(:where).with(:gtpay_tranx_id => @params[:gtpay_tranx_id]).and_return([])
        send_request(@params)
      end

      it "should assign transaction" do
        expect(assigns(:transaction)).to be_nil
      end

      it 'should redirect_to payment_mode_path' do
        expect(response).to redirect_to(payment_mode_path(:permalink => "interswitch"))
      end

      it 'should add error message' do
        expect(flash[:error]).to eq("Invalid Request!")
      end

    end
  end

end
