class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def selected_user
    session[:selected_user_id].present? ? User.find(session[:selected_user_id]) : current_user
  end
end
