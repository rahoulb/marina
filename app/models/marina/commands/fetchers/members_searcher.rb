require_relative '../fetcher'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/keys'

module Marina
  module Commands
    module Fetchers
      class MembersSearcher < Fetcher

        def do_fetch params = {}
          fetcher = basic_fetcher
          fetcher = fetcher.by_last_name(params[:last_name]) unless params[:last_name].blank?

          fetcher = filter fetcher, by: params if custom_fields_in params

          return fetcher
        end

        protected

        def basic_fetcher
          return data_store.by_visibility(visibility) if user.nil? || !user.can(:access_all_members)
          return data_store.all
        end

        def visibility
          return "all" if user.nil?
        end

        def filter members, parameters
          params = parameters[:by].stringify_keys

          fields = field_definitions.inject [] do | result, field_definition |
            result << field_definition if params.has_key? field_definition.name
            result
          end

          members.select do | member |
            matches = true
            fields.each do | field |
              matches = false unless field.matches(member, params[field.name])
            end
            matches
          end
        end

        def custom_fields_in params
          params.each do | key, value |
            return true if find_field_definition_called key.to_s
          end
        end

        def find_field_definition_called name
          field_definitions.find { | fd | fd.name.to_s == name }
        end
      end
    end
  end
end
