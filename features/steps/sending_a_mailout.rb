class Spinach::Features::SendingAMailout < Spinach::FeatureSteps
  include Logins
  include SubscriptionPlans
  include UiHelpers

  step 'I visit the dashboard and create a mailout' do
    visit '/'
    click_link I18n.t(:send_a_mailout)
    click_link I18n.t(:new_mailout)
    fill_in 'mailout-subject', with: 'My new mailout'
    fill_in_editor '#mailout-contents', with: 'This is my text'
  end

  step 'I send the mailout to all members' do
    check 'send-to-all-members'
    click_button I18n.t(:send)
  end

  step 'the mailout should be sent to all members' do
    pending 'step not implemented'
  end

  step 'the sending of it recorded' do
    pending 'step not implemented'
  end

  step 'I send the mailout to some plan members' do
    check 'Basic'
    check 'Premium'
    uncheck 'VIP'
    click_button I18n.t(:send)
  end

  step 'the mailout should be sent to those plan members' do
    pending 'step not implemented'
  end

  step 'I send the mailout to myself' do
    click_button I18n.t(:send_test_to_myself)
  end

  step 'the mailout should be sent to myself' do
    pending 'step not implemented'
  end

  step 'the sending of it is not recorded' do
    pending 'step not implemented'
  end

end
