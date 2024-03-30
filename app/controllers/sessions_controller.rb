class SessionsController < ApplicationController
    def new
    end
    
    def create
      user = Officer.authenticate(params[:username], params[:password])
      if user
        session[:officer_id] = officer.id
        redirect_to home_path, notice: "Logged in!"
      else
        flash.now.alert = "Username and/or password is invalid"
        render "new"
      end
    end
    
    def destroy
      session[:officer_id] = nil
      redirect_to home_path, notice: "Logged out!"
    end
  end