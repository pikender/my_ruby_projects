module Gtpay
  class Request
    attr_accessor :http_verb, :path, :params

    def initialize(http_verb, path, params = {})
      @path = path
      @http_verb = http_verb
      @params = params
    end

    def send_request
      case http_verb.to_sym
      when :post
        response = HTTParty.post(path, body: params.except(:headers).to_json, headers: params[:headers])
      when :put
        response = HTTParty.put(path, body: params.except(:headers).to_json, headers: params[:headers])
      when :delete
        response = HTTParty.delete(path, body: params.except(:headers).to_json, headers: params[:headers])
      else
        response = HTTParty.get(path, query: params.except(:headers), headers: params[:headers])
      end
      Gtpay::Response.new(response)
    end
  end
end
