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
	
	
	

  
