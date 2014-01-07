when_creating_a Marina::Db::Subscription::PaidPlan, auto_generate: [:name]
when_creating_a Marina::Db::Subscription::ReviewedPlan, auto_generate: [:name]
when_creating_a Marina::Db::Member, set: { first_name: 'Member', receives_mailshots: true }, auto_generate: [:last_name], generate: { email: -> { "#{8.random_letters}@example.com" } }
when_creating_a Marina::Db::Subscription, generate: { plan: -> { a_saved(Marina::Db::Subscription::BasicPlan) }, member: -> { a_saved(Marina::Db::Member) } }, set: { active: true, expires_on: 10.days.from_now }
