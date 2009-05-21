Feature: Article Comments
  In order view and add opinions on an article
  As a reader
  I want to be able to make and read article comments
	
	@focus
	Scenario: Creating article comments
	  Given the following active articles records
	 	| title                    | content                      |
	 	| Welcome to Minimal Pixel | We're very happy to see you! |
		And the article Welcome to Minimal Pixel has no comments
	  When I am on the Welcome To Minimal Pixel article page
		And I fill in "Name" with "Bob"
		And I fill in "Comment" with "I'm very happy to be here"
		And I press "Add"
	  Then I should see "Thank you for your comment"
		And the article Welcome to Minimal Pixel should have 1 comment
		And I should see "Bob"
		And I should see "I'm very happy to be here"
	
	
	
	

  
