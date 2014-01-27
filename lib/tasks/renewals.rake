namespace :marina do
  namespace :memberships do
    desc "Warn of impending renewals" 
    task :warn_of_impending_renewals => :environment do
      Rails.logger.info "About to check for impending renewals..."
      admin = Marina::Db::Member.by_username(Marina::Application.config.admin_username) || raise("Admin user #{Marina::Application.config.admin_username} not found")

      notifier = Marina::Commands::Jobs::RenewalNotifier.new user: admin
      Delayed::Job.enqueue notifier
      Rails.logger.info "...done"
    end
  end
end
