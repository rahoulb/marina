class MailoutsViewModel extends ViewModel
  constructor: ->
    super
    @subscriptionPlansDb = new SubscriptionPlansDb this
    @subscriptionPlansDb.load true

    @mailoutsDb = new MailoutsDb this, @subscriptionPlansDb
    @mailoutsDb.load true

  addMailout: ->
    @mailoutsDb.newItem(null).edit()

window.viewModel = new MailoutsViewModel

$(document).ready ->
  ko.applyBindings window.viewModel
