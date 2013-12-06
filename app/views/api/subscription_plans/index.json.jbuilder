json.subscription_plans plans do | plan |
  json.partial! '/api/subscription_plans/plan', plan: plan
end
