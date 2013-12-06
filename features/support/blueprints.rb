when_creating_a Marina::Db::Subscription::BasicPlan, auto_generate: [:name]
when_creating_a Marina::Db::Subscription::PaidPlan, auto_generate: [:name]
when_creating_a Marina::Db::Subscription::ReviewedPlan, auto_generate: [:name]
when_creating_a Marina::Db::Member, set: { first_name: 'Member' }, auto_generate: [:last_name], generate: { email: -> { "#{8.random_letters}@example.com" } }
when_creating_a Marina::Db::Subscription, generate: { plan: -> { a_saved(Marina::Db::Subscription::BasicPlan) }, member: -> { a_saved(Marina::Db::Member) } }
