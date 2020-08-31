class ApplicationController < ActionController::Base
    helper_method :search
  
    def current_user
        if session[:user_id]
            @user ||= Account.find(session[:user_id]) if session[:user_id]
        end 
    end

    def search
        @input = GooglePlaces::Client.new('AIzaSyDMCLs_nBIfA8Bw9l50nSRwLOUByiDel9U')
    end
end
