class MailoutsDb extends Db
  constructor: (viewModel, @subscriptionsPlanDb)->
    super viewModel, 'mailout', '/api/mailouts.json'

  newItem: (id)->
    new Mailout(id, this)

  itemDataFrom: (data)->
    data.mailouts

  toJS: (mailout)->
    mailout:
      subject: mailout.subject()
      from_address: mailout.fromAddress()
      send_to_all_members: mailout.sendToAllMembers()
      recipient_plan_ids: mailout.recipientPlanIds()
      test: mailout.testSend()


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

  save: ->
    $('form.mailout').validate()
    if $('form.mailout').valid()
      @db.save this, =>
        @testSend false

  sendTestToMyself: ->
    @testSend true
    @save()

window.MailoutsDb = MailoutsDb
window.Mailout = Mailout
