require 'active_support/core_ext/object/blank'

module Marina
  module Mailout

    def set_from_address
      self.from_address = sender.email if from_address.blank?
    end
  end
end
