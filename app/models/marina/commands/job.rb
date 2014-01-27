require_relative './secure'

module Marina
  module Commands
    # Base class for a job
    # As this is secure it expects to be given a permission symbol, which is then checked against a user object
    # However, when being created, the user is stored internally as a user_id and then loaded via the user method
    # This is for ease of serialisation/deserialisation
    #
    # Subclasses are expected to pass in a permission symbol and override the execute method
    class Job < Secure
      def initialize params = {}
        this_user = params.delete(:user)
        super params.merge(user_id: this_user.id)
      end

      def perform
        log "About to execute #{self.class.name}..."
        check_security!
        result = execute
        log "...#{self.class.name} completed with #{result.inspect}"
        return result
      rescue Exception => ex
        log "...#{self.class.name} failed with #{ex.inspect}", :error
        raise ex
      end

      def user
        Marina::Db::Member.find user_id if defined? Marina::Db && defined? Marina::Db::Member
      end

    end

  end
end
