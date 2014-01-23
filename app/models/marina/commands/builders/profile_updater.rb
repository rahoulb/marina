require_relative '../builder'
require 'active_support/core_ext/hash/slice'

module Marina
  module Commands
    module Builders
      class ProfileUpdater < Builder

        def check_security!
          raise Unauthorised.new if user.nil?
        end

        def do_update member, params
          raise Unauthorised.new if user != member
          params = params.slice(:username, :password, :password_confirmation, :title, :email, :first_name, :last_name) if user.current_subscription.nil?
          member.update_attributes! params
        end

      end
    end
  end
end
