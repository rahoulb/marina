class Marina::Email < ActionMailer::Base
  default from: "from@example.com"

  def mailout member, mailout
    @member = member
    @mailout = mailout

    mail to: member.email, from: mailout.from_address, subject: mailout.subject
  end
end
