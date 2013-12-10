class Spinach::Features::SigningUpToABasicPlan < Spinach::FeatureSteps
  step 'a configured site with a basic membership plan and a signup page' do
    @basic_membership_plan = a_saved Marina::Db::Subscription::BasicPlan, name: 'Basic'
    pending 'step not implemented'
  end

  step 'I visit the site and go to the signup page' do
    pending 'step not implemented'
  end

  step 'I enter my details for a basic membership' do
    pending 'step not implemented'
  end

  step 'my membership should be created' do
    pending 'step not implemented'
  end

  step 'I should be taken to my profile page' do
    pending 'step not implemented'
  end

  step 'an existing member with my email address' do
    pending 'step not implemented'
  end

  step 'I should see a message detailing the problem' do
    pending 'step not implemented'
  end

  step 'I should be offered a login as well as a registration form' do
    pending 'step not implemented'
  end
end
