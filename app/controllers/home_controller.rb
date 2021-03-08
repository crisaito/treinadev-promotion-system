class HomeController < ApplicationController
    def index 
    end

    def search
        @promotions = Promotion.where('name like ? OR description like ?',
                      "%#{params[:q]}%", "%#{params[:q]}%")
        @coupons = Coupon.where('code like ?', "%#{params[:q]}%")
    end
end