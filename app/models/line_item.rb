class LineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :cart
  
  after_save :delete_line_item_if_empty
  
  def total_price
    self.price * quantity
  end
  
  def decrement_quantity
    self.quantity -= 1
    self.save
  end
  
  def delete_line_item_if_empty
    self.destroy if self.quantity <= 0
  end
end
