when_creating_a Marina::Db::Subscription::PaidPlan, auto_generate: [:name]
when_creating_a Marina::Db::Subscription::ReviewedPlan, auto_generate: [:name]
when_creating_a Marina::Db::Member, set: { first_name: 'Member', receives_mailshots: true, password: 'secret', password_confirmation: 'secret', has_directory_listing: true }, auto_generate: [:last_name, :username], generate: { email: -> { "#{8.random_letters}@example.com" } }
when_creating_a Marina::Db::Subscription, generate: { plan: -> { a_saved(Marina::Db::Subscription::PaidPlan) }, member: -> { a_saved(Marina::Db::Member) } }, set: { active: true, expires_on: 10.days.from_now }
when_creating_a Marina::Db::FieldDefinition, auto_generate: [:name, :label], set: { kind: 'short_text' }
when_creating_a Marina::Db::AffiliateOrganisation, auto_generate: [:name], set: { discount: 10.0, applies_to_memberships: true, applies_to_tickets: true }
when_creating_a Marina::Db::Voucher, auto_generate: [:code]
when_creating_a Marina::Db::Voucher::FreeTime, auto_generate: [:code], set: { days: 10 }
when_creating_a Marina::Db::Voucher::Credit, auto_generate: [:code], set: { amount: 10.0 }
when_creating_a Marina::Db::Subscription::ReviewedPlan::Application, set: { status: 'awaiting_review' }, generate: { member: -> { a_saved Marina::Db::Member }, plan: -> { a_saved Marina::Db::Subscription::ReviewedPlan } }
