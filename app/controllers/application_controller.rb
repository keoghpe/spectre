class ApplicationController < ActionController::Base
  rescue_from Exception, :with => :handle_exception
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def handle_exception(e)
    class_name = self.class.to_s
    method_name = caller_locations(1, 1)[0].label.split(' ').last rescue ''

    Rails.logger.error "Exception => #{class_name}##{method_name} - #{e.class.name} : #{e.message}"+ "\n " + e.backtrace.join("\n ")
    raise e
  end
end

