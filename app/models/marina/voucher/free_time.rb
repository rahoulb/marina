module Marina
  module Voucher
    module FreeTime
      def apply_to member_or_application, payment_processor = nil
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
    end
  end
end
