module Marina
  module Voucher
    module FreeTime
      def apply_to member_or_application, payment_processor = NilPaymentProcessor.new
        member = nil
        application = nil
        if member_or_application.respond_to? :member
          member = member_or_application.member
          application = member_or_application
          application.update_attributes status: 'approved'
        else
          member = member_or_application
          application = nil
        end
        payment_processor.add_time_to member, self.days unless payment_processor.nil?
      end

      protected

      class NilPaymentProcessor
        def add_time_to member, days
          # do nothing
        end
      end
    end
  end
end
