class OfficesController < ApplicationController
  def index
    @offices = Office.includes(:move_ins).all
  end
  
  def new
  end

  def create
    o = Office.new(params[:office])
    if o.save
      redirect_to new_office_url
    else
      render :get_move_in
    end
  end

  def get_move_in
    render :get_move_in, :layout => false
  end
end
