Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  visit login_url
  fill_in "Username", :with => username
  fill_in "Password", :with => password
  click_button "Login"
end
