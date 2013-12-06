Feature: sending a mailout

  As a member of staff of the organisation
  I would like to send a mailout to various group members
  So that they can be kept up to date with the latest developments


  Background:
    Given I am logged in as a staff member
    And I have mailout permissions
    And there are several subscription plans configured
    And there are members in each subscription plan

  Scenario: sending to all 

    When I visit the dashboard and create a mailout
    And I send the mailout to all members
    Then the mailout should be sent to all members
    And the sending of it recorded

  Scenario: sending to specific subscription plans

    When I visit the dashboard and create a mailout
    And I send the mailout to some plan members
    Then the mailout should be sent to those plan members
    And the sending of it recorded

  Scenario: sending a test to myself

    When I visit the dashboard and create a mailout
    And I send the mailout to myself
    Then the mailout should be sent to myself
    And the sending of it is not recorded

