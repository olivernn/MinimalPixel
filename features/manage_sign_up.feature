Feature: Sign-up
	In order to use the app
	As a user
	I want to create an account
	
	Scenario: Complete a sign-up form
		Given I am not logged in
		When I choose to sign-up
		Then I should see a sign-up page
		
	Scenario: Successfully submit a sign-up form
		Given I have completed a sign-up form
		When I submit the form
		Then I should see my home page
		
	Scenario: Unsuccessfully submit a sign-up form
		Given I have not completed a sign-up form correctly
		When I submit the form
		Then I am told what I have done wrong
		