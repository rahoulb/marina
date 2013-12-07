Feature: managing subscription plans

  As an administrator on a site
  I would like to manage the subscription plans
  So that we can offer different service levels to our members

  Background:
    Given there are several subscription plans configured
    And there are members in each subscription plan

  Scenario: viewing existing plans

    Given I am logged in as an administrator
    When I visit the dashboard and look at subscription plans
    Then I should see each of the plans, along with their type and the number of members

  Scenario: adding a basic plan

    Given I am logged in as an administrator
    When I visit the dashboard and look at subscription plans
    And I add a basic plan 
    Then the new basic plan should be added to the system

  Scenario: adding a paid plan

    Given I am logged in as an administrator
    When I visit the dashboard and look at subscription plans
    And I add a paid plan, including payment details and subscription length
    Then the new paid plan should be added to the system

  Scenario: adding an approved plan

    Given I am logged in as an administrator
    When I visit the dashboard and look at subscription plans
    And I add an approved plan, including payment details, subscription length and supporting information
    Then the new approved plan should be added to the system

  Scenario: deactivating an existing plan

    Given I am logged in as an administrator
    When I visit the dashboard and look at subscription plans
    And I deactivate an existing plan
    Then the plan should be deactivated

