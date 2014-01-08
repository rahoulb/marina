require_relative '../builder'

module Marina
  module Commands
    module Builders
      class FieldDefinitionBuilder < Builder

        def initialize params = {}
          super params.merge(permission: :add_field_definitions)
        end
      end
    end
  end
end
