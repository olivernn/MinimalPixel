Feature: Manage Articles
  In order to make a blog
  As a an author
  I want to create and manage articles

	Scenario: Articles List
		Given the following active articles records
		 | title                    |
		 | Welcome To Minimal Pixel |
		 | Competition Winner       |
	  When I go to the list of articles
	  Then I should see "Welcome To Minimal Pixel"
		And I should see "Competition Winner"
	
	Scenario: Create a valid draft article
	  Given I have no articles
		And I am on the list of draft articles
	  When I follow "New Article"
		And I fill in "Title" with "Welcome to Minimal Pixel"
		And I fill in "Content" with "The best online portfolio tool!"
		And I press "Create"
	  Then I should see "Successfully created draft article"
		And I should see "Welcome to Minimal Pixel"
		And I should see "The best online portfolio tool!"
		And I should have 1 draft article
	
	Scenario: Viewing a published article
	  Given the following active article records
		 | title                    |
		 | Welcome To Minimal Pixel |
		And I am on the list of articles
	  When I follow "Welcome To Minimal Pixel"
	  Then I should see "Welcome To Minimal Pixel"
		And I should see "This is just a test article"
	
	Scenario: Publish a draft article
	  Given the following draft article records
		 | title                    |
		 | Welcome To Minimal Pixel |
		And I am on the list of draft articles
	  When I follow "Publish"
	  Then I should see "Successfully published article"
		And I should have 1 active article
	
	# this scenario fails because of the use of the session to track a user
	Scenario: Amend an article
	  Given the following draft article records
		 | title                    |
		 | Welcome To Minimal Pixel |
	  And  the following admins
		 | name   | password |
		 | admin  | secret   |
		And I am logged in as "admin" with password "secret"
		When I am on the Welcome To Minimal Pixel article page
	  And I follow "Edit"
		And I fill in "Title" with "Edited Welcome To Minimal Pixel"
		And I press "Update"
	  Then I should see "Successfully updated article"
		And I should see "Edited Welcome To Minimal Pixel"
	
	# this scenario fails because of the use of the session to track a user
	Scenario: Remove articles
	  Given the following active article records
		 | title                    |
		 | Welcome To Minimal Pixel |
	  And  the following admins
		 | name   | password |
		 | admin  | secret   |
		And I am logged in as "admin" with password "secret"
		When I am on the Welcome To Minimal Pixel article page
	  And I follow "Destroy"
	  Then I should have 0 draft articles
	  And I should have 0 active articles
	
	Scenario: Article Editing and Deleting Security
	  Given the following active article records
		 | title                    |
		 | Welcome To Minimal Pixel |
	  And I am on the Welcome To Minimal Pixel article page
	  And  the following users
		 | name   | password |
		 | bob    | secret   |
		And I am logged in as "bob" with password "secret"
	  When I am on the Welcome To Minimal Pixel article page
	  Then I should not see "Destroy"
		And I should not see "Edit"
	
	
	