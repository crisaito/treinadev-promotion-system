class AddUserToPromotion < ActiveRecord::Migration[6.0]
  def change
    add_reference :promotions, :user, null: false, foreign_key: true
  end
end
