require 'ostruct'
require_relative '../unauthorised'

module Marina
  module Commands
    module Fetchers
      class Authenticator < OpenStruct

        def authenticate username, password
          member = members.by_username(username)
          raise Marina::Commands::Unauthorised.new if member.nil? || !member.verify_password(password)
          yield member
        end

      end
    end
  end
end
