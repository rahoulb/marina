class MailoutsDb extends Db
  constructor: (viewModel, @subscriptionsPlanDb)->
    super viewModel, 'mailouts', '/api/mailouts.json'

  newItem: (id)->
    new Mailout(id, this)

  itemDataFrom: (data)->
    data.mailouts

  toJS: (mailout)->
    mailout:
      subject: mailout.subject()
      from_address: mailout.fromAddress()
      send_to_all_members: mailout.sendToAllMembers()
      recipients_plan_ids: mailout.recipientPlanIds()
      do_test_send: mailout.testSend()

class Mailout extends Model
  constructor: (id, db)->
    super id, db
    @subject = ko.observable ''
    @contents = ko.observable ''
    @fromAddress = ko.observable ''
    @sendToAllMembers = ko.observable false
    @testSend = ko.observable false

  updateAttributes: (data)->
    subject data.subject
    contents data.contents

  recipientPlanIds: ->
    return [] unless @db.subscriptionsPlanDb?
    results = []
    for plan in @db.subscriptionsPlanDb.items()
      results.push plan.id if plan.checked()
    return results

window.MailoutsDb = MailoutsDb
window.Mailout = Mailout
