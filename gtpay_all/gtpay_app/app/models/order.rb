class Order < ActiveRecord::Base
  attr_accessible :order_number, :status, :tranx_amount

  STATUS = {:incomplete => 'incomplete', :released => 'released', :cancelled => 'cancelled'}

  def status_incomplete?
    status == STATUS[:incomplete]
  end

  def status_released?
    status == STATUS[:released]
  end

  def status_cancelled?
    status == STATUS[:cancelled]
  end

  def cancel!
    update_attributes!(status: STATUS[:cancelled])
    Rails.logger.info "Cancel Order : #{id}"
  end
end
