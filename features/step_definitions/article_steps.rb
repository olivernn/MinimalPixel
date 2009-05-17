Given /^I have articles titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Factory(:draft_article, :title => title)
  end
end

Given /^The articles have been published$/ do
  Article.find(:all).each do |article|
    article.publish!
  end
end

Given /^I have no articles$/ do
  Article.delete_all
end

Then /^I should have ([0-9]+) draft articles?$/ do |count|
  Article.draft.size.should == count.to_i
end

Then /^I should have ([0-9]+) active articles?$/ do |count|
  Article.active.size.should == count.to_i
end