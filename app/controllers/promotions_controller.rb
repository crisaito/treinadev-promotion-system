class PromotionsController < ApplicationController
    before_action :authenticate_user!
    def index 
        @promotions = Promotion.all
    end

    def show
        @promotion = Promotion.find(params[:id])
        if @promotion.expiration_date < Date.today
            @promotion.expired!
            flash[:notice] = 'Esta promoção está expirada'
            @promotion.coupons.each do |coupon|
                coupon.inactive!
            end
        end
    end

    def new
        @promotion = Promotion.new
        @product_categories = ProductCategory.all
        @payment_methods = PaymentMethods.all
    end

    def create
        @promotion = Promotion.new(params.require(:promotion).permit(
            :name, 
            :description, 
            :code, 
            :discount_rate, 
            :coupon_quantity, 
            :expiration_date,
            product_category_ids: []))
        #@promotion.name = params[:promotion][:name]
        #@promotion.description = params[:promotion][:description]
        #@promotion.code = params[:promotion][:code]
        #@promotion.discount_rate = params[:promotion][:discount_rate]
        #@promotion.coupon_quantity = params[:promotion][:coupon_quantity]
        #@promotion.expiration_date = params[:promotion][:expiration_date]
        @promotion.user = current_user
        if @promotion.save
            redirect_to @promotion
        else
            @product_categories = ProductCategory.all
            render 'new'
        end

    end

    def generate_coupons
        @promotion = Promotion.find(params[:id])
        @promotion.generate_coupons!
        redirect_to @promotion, notice: t('.success')
   end

   def approve
    promotion = Promotion.find(params[:id])
    promotion.approve!(current_user)
    redirect_to promotion
   end
end