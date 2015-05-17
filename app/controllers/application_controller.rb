class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  # protect_from_forgery with: :exception
  
  # http://jamescpoole.com/2013/10/31/rails-4-csrf-protection-with-clients-using-apis/
  protect_from_forgery with: :null_session
end
