module SessionsHelper
  # Logs in the given user.
  # Because temporary cookies created using the session method are automatically encrypted,
  # this code is secure; there is no way for an attacker to use the session information to log in as the user.
  # Note: This applies only to temporary sessions initiated with the session method, though,
  # and is not the case for persistent sessions created using the cookies method.
  def log_in(user)
    session[:user_id] = user.id
  end

  # Remembers a user in a persistent session.
  # First, generating a remember token and saving its digest to the database
  # Then use cookies method to create permanent cookies for the user id and remember token.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Forgets a persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Returns the user corresponding to the remember token cookie.
  def current_user
    #return the current logged-in user (temporary session)
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)

    #check cookie (permanent session)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # Returns true if the given user is the current user.
  def current_user?(user)
    user == current_user
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end

  # Logs out the current user.
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Redirects to stored location (or to the default) and then delete it.
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
