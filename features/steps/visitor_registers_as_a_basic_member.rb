class Spinach::Features::VisitorRegistersAsABasicMember < Spinach::FeatureSteps
  step 'I visit the registration page' do
    visit "/public/subscription_plans/#{@plan.to_param}/registrations/new"
  end

  step 'I register as a basic member' do
    within 'form.registration' do
      fill_in 'first-name', with: 'George'
      fill_in 'last-name', with: 'Testington'
      fill_in 'username', with: 'georgiou'
      fill_in 'email', with: 'george@example.com'
      fill_in 'password', with: 'secret101'
      fill_in 'password_confirmation', with: 'secret101'
      check 'agrees-to-terms'
      check 'join-mailing-list'
      click_button I18n.t(:join)
    end
  end

  step 'I should be registered as a member' do
    @member = Marina::Db::Member.where(username: 'georgiou').first
    @member.wont_equal nil
  end

  step 'I register with invalid details' do
    within 'form.registration' do
      fill_in 'first-name', with: 'George'
      fill_in 'last-name', with: 'Testington'
      fill_in 'username', with: 'georgiou'
      fill_in 'email', with: 'george@example.com'
      fill_in 'password', with: ''
      fill_in 'password_confirmation', with: ''
      check 'agrees-to-terms'
      check 'join-mailing-list'
      click_button I18n.t(:join)
    end
  end

  step 'I should see an error message' do
    page.has_css?('.error-message').must_equal true
  end

  step 'I should have the option of registering again' do
    page.has_css?('form.registration').must_equal true
  end
end
