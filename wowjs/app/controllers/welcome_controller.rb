class WelcomeController < ApplicationController
  def index
    render json: ['Let Build some stuff']
  end
end
