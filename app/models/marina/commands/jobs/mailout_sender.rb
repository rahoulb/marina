require_relative '../job'
require_relative '../fetchers/recipient_fetcher'
module Marina
  module Commands
    module Jobs
      class MailoutSender < Job

        def initialize params = {}
          super params.merge(permission: :send_mailouts)
        end

        def execute
          recipient_fetcher.fetch do | recipients |
            log "...found #{recipients.size} recipients"
            recipients.each do | member |
              delivery = delivery_for member
              queue.enqueue delivery
            end
          end
        end

        def delivery_for member
          Marina::Commands::Jobs::IndividualMailoutDelivery.new user: user, member_id: member.id, mailout_id: mailout.id
        end

        def mailout
          Marina::Db::Mailout.find mailout_id
        end

        def queue
          Delayed::Job
        end

        def recipient_fetcher
          Marina::Commands::Fetchers::RecipientFetcher.new user: user, mailout: mailout
        end

      end
    end
  end
end
