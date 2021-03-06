class ApplicationController < ActionController::Base
  include Clearance::Controller
  protect_from_forgery with: :exception
  helper_method :current_time

  # We want the periods to start and end at midnight in Berlin, not UTC.
  # A possible improvement could be to configure a time zone for each event, instead of hardcoding it to Berlin.
  def current_time
    Time.now.in_time_zone("Berlin").to_date
  end

  private

  def require_admin
    require_login
    if current_user && !current_user.admin
      redirect_to root_path
    end
  end

  def require_coach
    unless current_user && current_user.coach
      store_location
      flash[:notice] = "You need to be signed in as coach"
      redirect_to coaches_sign_in_path
    end
  end

  def require_signed_out
    redirect_to logged_in_path if current_user
  end
end
