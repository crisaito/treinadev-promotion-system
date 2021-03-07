class HomeController < ApplicationController
    def index 
    end

    def search
        @promotions = Promotion.where('name like ? OR description like ?',
                      "%#{params[:q]}%", "%#{params[:q]}%")
    end
end