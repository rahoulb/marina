module Marina
  module Voucher
    module Credit
      def apply_to member, payment_processor = NilPaymentProcessor.new
        payment_processor.apply_credit_to member, amount 
      end

      protected

      class NilPaymentProcessor
        def apply_credit_to member, amount
          # do nothing
        end
      end
    end
  end
end
