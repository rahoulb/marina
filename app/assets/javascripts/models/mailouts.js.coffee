class MailoutsDb extends Db
  constructor: (viewModel)->
    super viewModel, 'mailouts', '/api/mailouts.json'

  newItem: (id)->
    new Mailout(id, this)

  itemDataFrom: (data)->
    data.mailouts

class Mailout extends Model
  constructor: (id, db)->
    super id, db
    @subject = ko.observable ''
    @contents = ko.observable ''
    @sendToAllMembers = ko.observable false

  updateAttributes: (data)->
    subject data.subject
    contents data.contents

window.MailoutsDb = MailoutsDb
window.Mailout = Mailout
