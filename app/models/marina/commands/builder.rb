require_relative './secure'

module Marina
  module Commands
    # Builds an object using the supplied data_store
    # @builder = MyBuilder.new user: @user, data_store: @data_store
    # @builder.build_from(@params) { | obj | ... }
    # The Builder subclass should set the required permission (self.permission = :do_something), and if set, the user will be checked (by calling user.can(:do_something))
    # If data_store.create!(params) does not build a new object then override do_create(params)
    class Builder < Secure

      def build_from params = nil
        check_security!
        yield do_create(params)
      end

      def update id, params = nil
        check_security!
        item = do_find id
        item.update_attributes! params
        yield item
      end

      def do_create params = nil
        data_store.create! params
      end

      def do_find id
        data_store.find id
      end

    end
  end
end
