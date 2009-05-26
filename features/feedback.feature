Feature: Send site feedback
  In order to ask for assistance or tell the website what I think
  As a visitor
  I want to be able to send a message to the website admins

  Scenario: Send a message
    Given I am on the list of articles
    When I follow "Contact Us"
		And I fill in "Name" with "Bob"
		And I fill in "Email" with "bob@example.com"
		And I fill in "Message" with "I freaking love this website"
		And I press "Send"
    Then I should see "Thank you for your message, we will get back to you shortly."
		# And the admins should receive my mail --not sure how to test this though!
  
  
  
