Rails.application.config.payment_processor = Marina::Application.config.payment_processor_class.constantize.new
