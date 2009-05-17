Feature: Manage Articles
  In order to make a blog
  As a an author
  I want to create and manage articles

	Scenario: Articles List
	  Given I have articles titled Welcome To Minimal Pixel, Competition Winner
		And The articles have been published
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
	  Given I have articles titled Welcome To Minimal Pixel
	  And The articles have been published
		And I am on the list of articles
	  When I follow "Welcome To Minimal Pixel"
	  Then I should see "Welcome To Minimal Pixel"
		And I should see "This is just some regular content"
	
	Scenario: Publish a draft article
	  Given I have articles titled Welcome To Minimal Pixel
		And I am on the list of draft articles
	  When I follow "Publish"
	  Then I should see "Successfully published article"
		And I should have 1 active article
		
	Scenario: Amend an article
	  Given I have articles titled Welcome To Minimal Pixel
	  And I am on the Welcome To Minimal Pixel article page
	  When I follow "Edit"
		And I fill in "Title" with "Edited Welcome To Minimal Pixel"
		And I press "Update"
	  Then I should see "Successfully updated article"
		And I should see "Edited Welcome To Minimal Pixel"
	
	
	
	
	
	