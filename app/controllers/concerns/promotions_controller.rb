class PromotionsController < ApplicationController
    def index 
        @promotions = Promotion.all
    end

    def show
        @promotion = Promotion.find(params[:id])
    end

    def new
        @promotion = Promotion.new
    end

    def create
        @promotion = Promotion.new(params.require(:promotion).permit(
            :name, 
            :description, 
            :code, 
            :discount_rate, 
            :coupon_quantity, 
            :expiration_date))
        #@promotion.name = params[:promotion][:name]
        #@promotion.description = params[:promotion][:description]
        #@promotion.code = params[:promotion][:code]
        #@promotion.discount_rate = params[:promotion][:discount_rate]
        #@promotion.coupon_quantity = params[:promotion][:coupon_quantity]
        #@promotion.expiration_date = params[:promotion][:expiration_date]
        if @promotion.save
            redirect_to @promotion
        else
            render 'new'
        end

    end

    def generate_coupons
        @promotion = Promotion.find(params[:id])
        (1..@promotion.coupon_quantity).each do |number|
            Coupon.create!(code: "#{@promotion.code}-#{'%04d' % number}", promotion: @promotion)
        end
        flash[:notice] = "Cupons gerados com sucesso"
        redirect_to @promotion
   end
end