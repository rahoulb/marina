require 'ostruct'
require_relative '../unauthorised'
require_relative '../loggable'

module Marina
  module Commands
    module Fetchers
      class Authenticator < OpenStruct
        include Loggable

        def authenticate username, password
          log "Authenticating #{username}..."
          member = members.by_username(username)
          log "...member #{member}"
          raise Marina::Commands::Unauthorised.new if member.nil? || !member.verify_password(password)
          log "...authenticated"
          member.record_login
          yield member
        end

      end
    end
  end
end
