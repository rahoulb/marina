@wip
Feature: managing site assets

  As a designer on a site
  I would like to manage the assets for the site
  So that I can build page layouts

  Background:
    Given there are several stylesheets and javascripts configured

  Scenario: listing assets

    Given I am logged in as an administrator
    When I visit the dashboard and look at the site assets
    Then I should see the javascripts and stylesheets

  Scenario: adding a stylesheet

    Given I am logged in as an administrator
    When I visit the dashboard and look at the site assets
    And I add a stylesheet
    Then the stylesheet should be added to the site assets

  Scenario: adding a javascript

    Given I am logged in as an administrator
    When I visit the dashboard and look at the site assets
    And I add a javascript
    Then the javascript should be added to the site assets

  Scenario: editing a stylesheet

    Given I am logged in as an administrator
    When I visit the dashboard and look at the site assets
    And I edit a stylesheet
    Then the stylesheet should be updated

    @wip
  Scenario: performing a bad edit on a stylesheet

    Given I am logged in as an administrator
    When I visit the dashboard and look at the site assets
    And I edit a stylesheet with bad syntax
    Then the stylesheet should not be updated
    And I should see an error message

  Scenario: editing a javascript

    Given I am logged in as an administrator
    When I visit the dashboard and look at the site assets
    And I edit a javascript
    Then the javascript should be updated

    @wip
  Scenario: performing a bad edit on a javascript

    Given I am logged in as an administrator
    When I visit the dashboard and look at the site assets
    And I edit a javascript with bad syntax
    Then the javascript should not be updated
    And I should see an error message

  Scenario: deleting a stylesheet

    Given I am logged in as an administrator
    When I visit the dashboard and look at the site assets
    And I delete a stylesheet
    Then the stylesheet should be deleted

  Scenario: deleting a javascript

    Given I am logged in as an administrator
    When I visit the dashboard and look at the site assets
    And I delete a javascript
    Then the javascript should be deleted
