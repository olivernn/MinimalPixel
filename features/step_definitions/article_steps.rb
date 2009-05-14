Given /^I have articles titled (.+)$/ do |titles|
  titles.split(', ').each do |title|
    Article.create!(:title => title,
                    :content => "This is just some regular content",
                    :status => "draft",
                    :date => Time.now)
  end
end

Given /^The articles have been published$/ do
  Article.find(:all).each do |article|
    article.publish!
  end
end

