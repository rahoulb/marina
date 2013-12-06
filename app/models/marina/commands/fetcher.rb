require 'ostruct'
require_relative './unauthorised'

module Marina
  module Commands
    # Expected that this is subclassed
    # USAGE: 
    #
    # @my_fetcher = MyFetcher.new user: @user, data_store: @data_store
    #
    # The user is expected to respond to #can(permission) - returning true or false
    # If the fetcher's permission property is set, then the user is asked can(permission) and if false then an Marina::Commands::Unauthorised is raised (likewise if the user is nil)
    # If the fetcher's permission property is nil, then no tests are made (and the user can be nil)
    # The data_store is expected to respond to #all, fetching the actual data.  If the data_store responds to a different message, or you would like to vary the results based upon parameters, override #do_fetch
    #
    class Fetcher < OpenStruct

      def fetch params = nil
        check_security
        yield do_fetch(params) if block_given?
      end

      def do_fetch params = nil
        data_store.all
      end

      protected

      def check_security
        return if permission.nil?
        raise Unauthorised.new if user.nil? || !user.can(permission)
      end
    end
  end
end
