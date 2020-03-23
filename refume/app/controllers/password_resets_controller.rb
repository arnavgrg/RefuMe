class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      #Sets the password reset attributes
      @user.create_reset_digest
      #Sends password reset email.
      UserMailer.password_reset(@user).deliver_now
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end

  def edit
  end

  def update
    # password cannot be empty
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    # password has been reset successfully
    elsif @user.update_attributes(user_params)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    # invalid password reset
    else
      render 'edit'
    end
  end

  private
    #mass assignment for password
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    #get user based on the given email address
    def get_user
      @user = User.find_by(email: params[:email])
    end

    # Confirms a valid user.
    def valid_user
      #make sure the user exists, is valid, activated, and authenticated.
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end

    # Check if a password reset is expired.
    # Checks expiration of reset token.
    # The password reset link will be expired in 2 hours.
   def check_expiration
     if @user.password_reset_expired?
       flash[:danger] = "Password reset has expired."
       redirect_to new_password_reset_url
     end
   end

end
