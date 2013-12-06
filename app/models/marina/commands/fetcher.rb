require 'ostruct'
require_relative './secure'

module Marina
  module Commands
    # Expected that this is subclassed
    # USAGE: 
    #
    # @my_fetcher = MyFetcher.new user: @user, data_store: @data_store
    #
    # As this is a descendant of Marina::Commands::Secure, if a permission is passed in, then the user is tested for that permission
    # The data_store is expected to respond to #all, fetching the actual data.  If the data_store responds to a different message, or you would like to vary the results based upon parameters, override #do_fetch
    #
    class Fetcher < Secure

      def fetch params = nil
        check_security!
        yield do_fetch(params)
      end

      def do_fetch params = nil
        data_store.all
      end

    end
  end
end
