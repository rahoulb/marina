require_relative '../job'

module Marina
  module Commands
    module Jobs
      class IndividualMailoutDelivery < Job

        def execute
          email_for(member).deliver
          mailout.record_delivery_to member
        end

        def email_for member
          ::Marina::Email.mailout member, mailout
        end

        def mailout
          Marina::Db::Mailout.find mailout_id
        end

        def member
          Marina::Db::Member.find member_id
        end
      end
    end
  end
end
