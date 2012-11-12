class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email].downcase)
    if user && user.authenticate(params[:password])
      #sign in
      sign_in user # function that has to be written
      redirect_to user
    else
      #displary error message
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end    

  def destroy
    sign_out
    redirect_to root_url
  end

end
