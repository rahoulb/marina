class SubscriptionPlansDb extends Db
  constructor: (viewModel)->
    super viewModel, 'subscription-plan', "/api/subscription_plans.json"

  newItem: (id)->
    new SubscriptionPlan id, this

  itemDataFrom: (data)->
    data.subscriptionPlans

class SubscriptionPlan extends Model
  constructor: (id, db)->
    super id, db
    @name = ko.observable ''
    @checked = ko.observable false

  updateAttributes: (data)->
    @name data.name

window.SubscriptionPlansDb = SubscriptionPlansDb
window.SubscriptionPlan = SubscriptionPlan
