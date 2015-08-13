module SessionsHelper

  # Logs in the given user
  def log_in (user)
    session[:user_id] = user.id
    current_user
  end

  # Remembers a user in a persistent session
  def remember (user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forgets a persistent session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Get current user
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Is user logged in?
  def logged_in?
    !current_user.nil?
  end

  # Logging out
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default)
  def redirect_back_or (default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores a location
  def store_location
    session[:forwarding_url] = request.url if request.get?
  end

end
