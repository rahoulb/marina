require_relative '../loggable'

module Marina
  module Commands
    module Jobs
      class PinPaymentSubscriberDetailsJob < Struct.new(:member_id)
        include Loggable

        def perform
          log "About to fetch subscriber details for member #{member_id} from Pin Payments..."
          details = payment_processor.get_subscriber_details member_id
          log "...details retrieved"
          plan = plan_by_feature_level details.feature_level
          log "...plan retrieved"
          subscription = member.current_subscription || member.build_subscription
          subscription.update_attributes! active: details.active, expires_on: details.active_until, plan: plan, lifetime_subscription: details.lifetime_subscription, credit: details.credit, identifier: details.identifier
          log "...subscription updated"
          log_transaction_for member
          log "...transaction logged"
          log "...done"
        end

        def payment_processor
          Rails.application.config.payment_processor
        end

        def member
          Marina::Db::Member.where(payment_processor_id: member_id).first || Marina::Db::Member.find(member_id)
        end

        def plan_by_feature_level feature_level
          Marina::Db::Subscription::Plan.by_feature_level feature_level
        end

        def log_transaction_for member
          Marina::Db::LogEntry::Transaction.create! owner: member, message: member.current_subscription.inspect
        end

      end
    end
  end
end
