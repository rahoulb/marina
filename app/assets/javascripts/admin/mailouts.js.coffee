class MailoutsViewModel extends ViewModel
  constructor: ->
    super
    @mailoutsDb = new MailoutsDb this
    @mailoutsDb.load true
    @subscriptionPlansDb = new SubscriptionPlansDb this
    @subscriptionPlansDb.load true

  addMailout: ->
    @mailoutsDb.newItem(null).edit()

window.viewModel = new MailoutsViewModel

$(document).ready ->
  ko.applyBindings window.viewModel
