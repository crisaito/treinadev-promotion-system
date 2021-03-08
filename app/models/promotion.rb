class Promotion < ApplicationRecord
    has_many :coupons
    has_one :promotion_approval
    has_many :product_category_promotions
    has_many :product_categories, through: :product_category_promotions
    belongs_to :user

    validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
    validates :code, uniqueness: true

    def generate_coupons!
        Coupon.transaction do
            (1..coupon_quantity).each do |number|
                coupons.create!(code: "#{code}-#{'%04d' % number}")
            end
        end
    end

    def approve!(approval_user)
        return false if approval_user == user
            PromotionApproval.create(promotion: self, user: approval_user)
    end

    def approved?
        #PromotionApproval.find_by(promotion: self)
        promotion_approval
    end

    def approver
        promotion_approval.user
    end
end
