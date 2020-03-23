class SessionsController < ApplicationController
  def new
  end

  def create
    # input is in this format { session: { password: "foobar", email: "user@example.com" } }
    # that's why we need nested hash
    user = User.find_by(email: params[:session][:email].downcase)
    #check if user exists and is valid
    if user && user.authenticate(params[:session][:password])
      # log in user only if the user is activated
      if user.activated?
        log_in user
        # remember user until they log out if remember_me check box is clicked
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # Create an error message.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    # Allow users to log out only if they have already logged in
    log_out if logged_in?
    redirect_to root_url
  end
end
