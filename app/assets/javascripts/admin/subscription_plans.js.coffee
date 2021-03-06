class SubscriptionPlansViewModel extends ViewModel
  constructor: ->
    super
    @subscriptionPlansDb = new SubscriptionPlansDb this
    @subscriptionPlansDb.load true

  newPaidPlan: ->
    plan = @subscriptionPlansDb.newItem null
    plan.type 'Marina::Db::Subscription::PaidPlan'
    plan.edit()

  newReviewedPlan: ->
    plan = @subscriptionPlansDb.newItem null
    plan.type 'Marina::Db::Subscription::ReviewedPlan'
    plan.edit()

window.viewModel = new SubscriptionPlansViewModel

$(document).ready ->
  ko.applyBindings window.viewModel
