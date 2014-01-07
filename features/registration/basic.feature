Feature: visitor registers as a basic member

  As a visitor to the site
  I would like to register as a basic member
  So that I can join the community

  Scenario: basic registration

    When I visit the registration page
    And I register as a basic member
    Then I should be registered as a member

  Scenario: invalid registration

    When I visit the registration page
    And I register with invalid details
    Then I should see an error message
    And I should have the option of registering again

  Scenario: registration with extra fields

    Given that the basic plan requires additional fields
    When I visit the registration page
    And I register as a basic member, including those additional fields
    Then I should be registered as a member

  Scenario: failed registration with extra fields

    Given that the basic plan requires additional fields
    When I visit the registration page
    And I register as a basic member, but miss out those additional fields
    Then I should see an error message
    And I should have the option of registering again


