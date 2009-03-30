Feature: Manage create_projects
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  Scenario: Register new create_project
    Given I am on the new create_project page
    And I press "Create"

  Scenario: Delete create_project
    Given the following create_projects:
      ||
      ||
      ||
      ||
      ||
    When I delete the 3rd create_project
    Then I should see the following create_projects:
      ||
      ||
      ||
      ||
