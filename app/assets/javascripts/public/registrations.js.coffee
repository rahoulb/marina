class RegistrationsViewModel extends ViewModel
  constructor: ->
    super
    @subscriptionPlansDb = new SubscriptionPlansDb this
    @subscriptionPlansDb.load true, =>
      planId = parseInt($('#page-info').attr('data-subscription-plan-id'))
      plan = @subscriptionPlansDb.find planId
      plan.select() if plan?

    @member = new Member

class Member extends Model
  constructor: ->
    super null, null
    @firstName = ko.observable ''
    @lastName = ko.observable ''
    @email = ko.observable ''
    @username = ko.observable ''
    @password = ko.observable ''
    @passwordConfirmation = ko.observable ''
    @agreesToTerms = ko.observable false
    @joinMailingList = ko.observable true

  save: ->




window.viewModel = new RegistrationsViewModel

$(document).ready ->
  ko.applyBindings window.viewModel
