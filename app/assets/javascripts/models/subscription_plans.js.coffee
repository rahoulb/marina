class SubscriptionPlansDb extends Db
  constructor: (viewModel)->
    super viewModel, 'subscription-plan', "/api/subscription_plans.json"

  newItem: (id)->
    new SubscriptionPlan id, this

  itemDataFrom: (data)->
    data.subscriptionPlans

  urlFor: (plan)->
    "/api/subscription_plans/#{plan.id}"

  toJS: (plan)->
    plan:
      name: plan.name()
      type: plan.type()
      price: plan.price()
      length: plan.length()
      supporting_information_label: plan.supportingInformationLabel()
      supporting_information_description: plan.supportingInformationDescription()
      active: plan.active()

class SubscriptionPlan extends Model
  constructor: (id, db)->
    super id, db
    @name = ko.observable ''
    @type = ko.observable ''
    @price = ko.observable 0
    @length = ko.observable 1
    @supportingInformationLabel = ko.observable ''
    @supportingInformationDescription = ko.observable ''
    @active = ko.observable true

    @paidPlan = ko.computed =>
      @type() == 'Marina::Db::Subscription::PaidPlan'
    @reviewedPlan = ko.computed =>
      @type() == 'Marina::Db::Subscription::ReviewedPlan'
    @numberOfMembers = ko.observable 0
    @checked = ko.observable false

  updateAttributes: (data)->
    @name data.name
    @type data.type
    @numberOfMembers data.numberOfMembers
    @price data.price
    @length data.length
    @supportingInformationLabel data.supportingInformationLabel
    @supportingInformationDescription data.supportingInformationDescription
    @active data.active

  save: ->
    super if $('form.subscription-plan').valid()

window.SubscriptionPlansDb = SubscriptionPlansDb
window.SubscriptionPlan = SubscriptionPlan
