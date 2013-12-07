module Marina
  module Commands
    module Loggable

      def log message, level = :info
        return if logger.nil?
        logger.send level, message
      end

      def logger
        return ::Rails.logger if defined? ::Rails
      end
    end
  end
end
