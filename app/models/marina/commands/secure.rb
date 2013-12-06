require 'ostruct'
require_relative './unauthorised'

module Marina
  module Commands
    # The user is expected to respond to #can(permission) - returning true or false
    # If the fetcher's permission property is set, then the user is asked can(permission) and if false then an Marina::Commands::Unauthorised is raised (likewise if the user is nil)
    # If the fetcher's permission property is nil, then no tests are made (and the user can be nil)
    #
    class Secure < OpenStruct

      def check_security!
        return if permission.nil?
        raise Unauthorised.new if user.nil? || !user.can(permission)
      end
    end
  end
end
