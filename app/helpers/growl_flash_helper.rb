module GrowlFlashHelper
  ALERT_TYPES = {alert: :danger, info: :info, notice: :success, warning: :warning}

  def growl_flash
    flash_messages = []
    flash.each do |type, message|
      next if message.blank?
      flash_messages << { message: message, type: ALERT_TYPES[type.to_sym] }
    end
    flash_messages
  end

end
