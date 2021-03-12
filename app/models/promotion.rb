class Promotion < ApplicationRecord
    has_many :coupons
    has_one :promotion_approval
    has_many :product_category_promotions
    has_many :product_categories, through: :product_category_promotions
    belongs_to :user

    validates :name, :code, :discount_rate, :coupon_quantity, :expiration_date, presence: true
    validates :code, uniqueness: true

    enum status: { active: 0, inactive: 5, expired: 10 }

    #validate :expiration_date_cannot_be_in_the_past

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

    private
    def expiration_date_cannot_be_in_the_past
        if self.expiration_date < Date.today
            errors.add(:expiration_date, 'Esta promoção está expirada')
        end
    end
end
