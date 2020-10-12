class ContactController < ApplicationController

    def index
        render json: Contact.where(account_id: params[:id])
    end

end

