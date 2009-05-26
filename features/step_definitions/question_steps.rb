Given /^I have no questions$/ do
  Question.delete_all
end

Then /^I should have ([0-9]+) questions?$/ do |count|
  Question.count.should == count.to_i
end
