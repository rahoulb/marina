class Marina::Db::Voucher < ActiveRecord::Base
  def apply_to member_or_application, payment_processor
    raise "Subclass to implement"
  end

  class << self
    def called code
      where(code: code).first
    end
  end

end
