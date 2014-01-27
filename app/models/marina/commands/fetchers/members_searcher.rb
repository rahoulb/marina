require_relative '../fetcher'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/hash/keys'

module Marina
  module Commands
    module Fetchers
      class MembersSearcher < Fetcher

        def do_fetch params = {}
          fetcher = if user.nil?
                      basic_fetcher
                    elsif user.can(:access_all_members)
                      all_member_fetcher
                    elsif user.current_subscription_plan.nil?
                      basic_fetcher
                    else
                      privacy_fetcher
                    end
          fetcher = fetcher.by_last_name(params[:last_name]) unless params[:last_name].blank?

          fetcher = filter fetcher, by: params if custom_fields_in params
          fetcher = privacy_filter fetcher if !user.nil? && !user.current_subscription_plan.nil?

          return fetcher
        end

        protected

        def basic_fetcher
          data_store.visible_to_all
        end

        def all_member_fetcher
          data_store
        end

        def privacy_fetcher
          data_store.visible_to_members
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

        def privacy_filter members
          members.select do | member |
            (member.visible_to == 'all') || ((member.visible_to == 'some') && member.visible_plans.include?(user.current_subscription_plan.id))
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
