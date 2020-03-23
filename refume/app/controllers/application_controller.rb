class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include UsersHelper
  include MatchesHelper
  include AccountActivationsHelper
end
