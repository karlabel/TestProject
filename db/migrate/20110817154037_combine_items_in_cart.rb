class CombineItemsInCart < ActiveRecord::Migration
  def self.up
    Cart.all.each do |cart|
      # Counts the number of different products in the cart and places them in sums
      sums = cart.line_items.group(:product_id).sum(:quantity)
      
      sums.each do |product_id, quantity|
        # On each sums (so each product), if quantity was over 1, delete every row and just make a new one with correct quantity
        if quantity > 1
          cart.line_items.where(:product_id => product_id).delete_all
          
          cart.line_items.create(:product_id => product_id, :quantity=>quantity)
        end
      end
    end
  end

  def self.down
    # Split items with quantity > 1 into seperate items all with quantity 1
    LineItem.where("quantity>1").each do |line_item|
      # Add individual items
      line_item.quantity.times do
        LineItem.create :cart_id=>line_item.cart_id, :product_id=>line_item.product_id, :quantity=>1
      end
      
      # Now remove the original item.  Seems backwards but we have the reference to it here so it works
      line_item.destroy
    end
  end
end
