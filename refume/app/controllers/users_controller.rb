class UsersController < ApplicationController
  # To update personal information, the user must already log in;
  # and that user can only modify his/her own information.
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update, :show]

  def show
    #find_by method automatically does the sanity check on user input
    #to prevent SQL injection
    #@user = User.find(params[:id])
    @user = User.find_by_id(params[:id])
    #get all the matched mentors/mentees for this user
    @matches = nil
    if @user.role == "Mentee"
      @matches = Match.where(mentee_id: @user.id)
    elsif @user.role == "Mentor"
      @matches = Match.where(mentor_id: @user.id)
    end

    #retrieve all the mentors/mentees names
    @mentors = []
    @mentees = []
    @matches = [] if @matches.nil?
    @matches.each do |match|
      if @user.role == "Mentor"
        user = User.find_by_id(match.mentee_id)
        @mentees << user
      else
        user = User.find_by_id(match.mentor_id)
        @mentors << user
      end
    end

  end

  def new
    if logged_in?
      flash[:danger] = "Please log out before signing up."
      redirect_to(root_url)
    else
      @user = User.new
    end
  end

  def create

=begin
    encrypted_user_params = {}
    user_params.each do |key, value|
      if key != 'password' && key != 'password_confirmation'
        encrypted_user_params[key] = SymmetricEncryption.encrypt(value)
      else
        encrypted_user_params[key] = value
      end
    end

    p "_________________"
    p encrypted_user_params
    p "_________________"
=end
    @user = User.new(user_params)
    if @user.save
      # send activation link to user email
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "Please check your email to activate your account."

      #for local testing
      #if @user.role == 'Mentee'
      #  get_match(@user)
      #end

      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find_by_id(params[:id])
  end

  def update
    @user = User.find_by_id(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private
    #handle mass assignment
    def user_params
      params.require(:user).permit(:name, :email, :age, :country, :language,
                                   :role, :zipcode, :goals, :bio, :password, :password_confirmation)
    end

    # Before filters
    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        #We store the location where the users want to go
        #and then ask them to log in, once they log in, we will
        #redirect them to that location.
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find_by_id(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def get_match(user)
      user_profile = []
      user_profile << user.email
      user_profile << user.country
      user_profile << user.language
      user_profile << user.goals
      user_profile << user.bio
      mentee = user_profile.join('|')

      mentors_profile = User.where(role: 'Mentor')
      return if mentors_profile.nil?
      mentors = []

      mentors_profile.each do |mentor|
        mentor_profile = []
        mentor_profile << mentor.email
        mentor_profile << mentor.country
        mentor_profile << mentor.language
        mentor_profile << mentor.goals
        mentor_profile << mentor.bio
        mentors << mentor_profile.join('|')
      end

      # find match for this mentee
      # It returns a list of mentors email
      mentors_email = find_match(mentee, mentors)

      # no matches found
      if !mentors_email.nil? && !mentors_email.empty?
        # save the result to the database
        # get the correspondingly mentors by email
        mentors_email.each do |mentor_email|
          mentor = User.find_by(email: mentor_email)
          Match.create(mentor_id: mentor.id, mentee_id: user.id).save
        end
      end

    end
end
