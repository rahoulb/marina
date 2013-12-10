Feature: signing up to a basic plan

  As a visitor to a marina site
  I would like to sign up as a basic member
  So that I can receive emails and access information on the site

  Scenario: successful signup

    Given a configured site with a basic membership plan and a signup page
    When I visit the site and go to the signup page
    And I enter my details for a basic membership
    Then my membership should be created
    And I should be taken to my profile page

  Scenario: email already in use

    Given a configured site with a basic membership plan and a signup page
    And an existing member with my email address
    When I visit the site and go to the signup page
    And I enter my details for a basic membership
    Then I should see a message detailing the problem
    And I should be offered a login as well as a registration form

