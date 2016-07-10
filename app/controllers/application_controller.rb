class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  around_filter :record_memory if Rails.env.production?

  def selected_user
    @selected_user = (session[:selected_user_id].present? && User.where(id: session[:selected_user_id]).first.present?) ? User.where(id: session[:selected_user_id]).first : current_user

    @selected_user
  end

  def record_memory
    process_status = File.open("/proc/#{Process.pid}/status")
    13.times {process_status.gets}
    res_before_action = process_status.gets.split[1].to_i
    process_status.close
    yield
    process_status = File.open("/proc/#{Process.pid}/status")
    13.times {process_status.gets}
    res_after_action = process_status.gets.split[1].to_i
    process_status.close
    logger.info("CONSUME MEMORY: #{res_after_action - res_before_action} KB\t NOW #{res_after_action} KB\t #{request.url}")
  end
end
