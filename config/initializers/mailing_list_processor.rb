Rails.application.config.mailing_list_processor = Marina::Application.config.mailing_list_processor_class.constantize.new
