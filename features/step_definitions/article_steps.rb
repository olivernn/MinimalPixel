Given /^I have articles titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Article.create!(:title => title,
                    :content => "This is just some regular content",
                    :status => "draft")
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

Then /^I should have ([0-9]+) draft article$/ do |count|
  Article.draft.size.should == count.to_i
end

Then /^I should have ([0-9]+) active article$/ do |count|
  Article.active.size.should == count.to_i
end