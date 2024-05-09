class User < ActiveRecord::Base
  has_many :favorites

  def disable_report_delivery
    update_attribute(:report_delivery, false)
  end

  def enable_report_delivery
    update_attribute(:report_delivery, true)
  end
end
