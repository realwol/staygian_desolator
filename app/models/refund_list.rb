class RefundList < ActiveRecord::Base
  belongs_to :order

  def get_refund_type
    (self.order.amount.to_f == self.refund_amount.to_f).present? ? '全部退款' : '部分退款'
  end
end
