Marina::Application.config.action_mailer.delivery_method = :smtp
Marina::Application.config.action_mailer.smtp_settings = { 
  address: Marina::Application.config.smtp_address,
  port: Marina::Application.config.smtp_port,
  user_name: Marina::Application.config.smtp_user_name,
  password: Marina::Application.config.smtp_password,
  domain: Marina::Application.config.smtp_domain,
  authentication: Marina::Application.config.smtp_authentication.to_sym
}

