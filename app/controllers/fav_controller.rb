class FavController < ApplicationController

    def index
        render json: Favs.where(account_id: params[:id])
    end

    def create
        
    end

end