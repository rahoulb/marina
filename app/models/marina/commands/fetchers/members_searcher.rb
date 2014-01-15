require_relative '../fetcher'
require 'active_support/core_ext/object/blank'

module Marina
  module Commands
    module Fetchers
      class MembersSearcher < Fetcher

        def do_fetch params = {}
          fetcher = data_store.by_visibility(visibility)
          fetcher = fetcher.by_last_name(params[:last_name]) unless params[:last_name].blank?

          return fetcher
        end

        protected

        def visibility
          return "all" if user.nil?
        end
      end
    end
  end
end
