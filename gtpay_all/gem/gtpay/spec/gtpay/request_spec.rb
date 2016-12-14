require 'spec_helper'

module Gtpay
  describe Request do
    before do
      @path = 'http://base_uri/some_path'
      @params = { param1: 'value1', param2: 'value2', headers: { header1: 'h_value1'} }
      @url = 'http://base_uri/some_path'
      @response = {}
    end

    describe 'send_request' do
      context 'get' do
        before do
          @http_verb = :get
          @request_obj = Gtpay::Request.new(@http_verb, @path, @params)
          HTTParty.stub!(:get).with(@url, query: @params.except(:headers), headers: @params[:headers]).and_return(@response)
        end
        it 'should send get request' do
          HTTParty.should_receive(:get).with(@url, query: @params.except(:headers), headers: @params[:headers])
          @request_obj.send_request
        end
        it { expect(@request_obj.send_request).to be_instance_of(Gtpay::Response) }
      end
      context 'put' do
        before do
          @http_verb = :put
          @request_obj = Gtpay::Request.new(@http_verb, @path, @params)
          HTTParty.stub!(:put).with(@url, body: @params.except(:headers).to_json, headers: @params[:headers]).and_return(@response)
        end
        it 'should send get request' do
          HTTParty.should_receive(:put).with(@url, body: @params.except(:headers).to_json, headers: @params[:headers])
          @request_obj.send_request
        end
        it { expect(@request_obj.send_request).to be_instance_of(Gtpay::Response) }
      end
      context 'delete' do
        before do
          @http_verb = :delete
          @request_obj = Gtpay::Request.new(@http_verb, @path, @params)
          HTTParty.stub!(:delete).with(@url, body: @params.except(:headers).to_json, headers: @params[:headers]).and_return(@response)
        end
        it 'should send get request' do
          HTTParty.should_receive(:delete).with(@url, body: @params.except(:headers).to_json, headers: @params[:headers])
          @request_obj.send_request
        end
        it { expect(@request_obj.send_request).to be_instance_of(Gtpay::Response) }
      end
      context 'post' do
        before do
          @http_verb = :post
          @request_obj = Gtpay::Request.new(@http_verb, @path, @params)
          HTTParty.stub!(:post).with(@url, body: @params.except(:headers).to_json, headers: @params[:headers]).and_return(@response)
        end
        it 'should send get request' do
          HTTParty.should_receive(:post).with(@url, body: @params.except(:headers).to_json, headers: @params[:headers])
          @request_obj.send_request
        end
        it { expect(@request_obj.send_request).to be_instance_of(Gtpay::Response) }
      end
    end
  end
end
