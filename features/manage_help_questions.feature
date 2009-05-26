Feature: Frequently Asked Questions
  In order to help users of the website
  As a admin
  I want to be able to maintain a list of FAQs

	Scenario: Create a valid question and answer
	  Given I have no questions
		And the following admins
		 | login | password |
 		 | admin | secret   |
		And I am logged in as "admin" with password "secret"
	  And I am on the list of questions
		When I follow "New Question"
		And I fill in "Question" with "What is the meaning of life"
		And I fill in "Answer" with "47"
		And I press "Create"
	  Then I should have 1 question
		And I should see "What is the meaning of life?"
		
	Scenario: Edit an existing question
	  Given the following question records
	  | question                            | answer                   |
	  | Why did the chicken cross the road? | To get to the other side |
		And the following admins
		 | login | password |
 		 | admin | secret   |
		And I am logged in as "admin" with password "secret"
	  And I am on the list of questions
		And I follow "Why did the chicken cross the road?"
	  And I follow "Edit Question"
		And I fill in "Answer" with "Because he was sick of these stupid questions"
		And I press "Update"
	  Then I should see "Why did the chicken cross the road?"
		And I should see "Because he was sick of these stupid questions"
	
	Scenario: Viewing the questions as a user
	  Given the following question records
	  | question                            | answer                   |
	  | Why did the chicken cross the road? | To get to the other side |
	  When I am on the list of questions
		And I follow "Why did the chicken cross the road?"
	  Then I should see "Why did the chicken cross the road?"
		And I should see "To get to the other side"
		And I should not see "Edit Question"
		And I should not see "New Question"
	
	
	