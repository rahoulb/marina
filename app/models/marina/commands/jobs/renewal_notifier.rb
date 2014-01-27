require_relative '../job'

module Marina
  module Commands
    module Jobs
      class RenewalNotifier < Job
        def initialize params = {}
          super params.merge(permission: :send_renewal_notifications)
        end

        def execute
          log "Renewal notifications..."
          log "...about to send two week renewals..."
          two_week_renewals.each do | member |
            log "...#{member.email}..."
            member.first_renewal ? mailing_list_processor.initial_two_week_renewal_notification(member) : mailing_list_processor.two_week_renewal_notification(member)
          end
          log "...about to send four week renewals..."
          four_week_renewals.each do | member |
            log "...#{member.email}..."
            member.first_renewal ? mailing_list_processor.initial_four_week_renewal_notification(member) : mailing_list_processor.four_week_renewal_notification(member)
          end
          log "...done"
        end

        def two_week_renewals
          Marina::Db::Member.renewal_due_in_two_weeks
        end

        def four_week_renewals
          Marina::Db::Member.renewal_due_in_four_weeks
        end

        def mailing_list_processor
          Marina::Application.config.mailing_list_processor
        end
      end
    end
  end
end
