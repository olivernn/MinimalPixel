Given /I am on the new create_project page/ do
  visit "/create_projects/new"
end

Given /^the following create_projects:$/ do |create_projects|
  CreateProject.create!(create_projects.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) create_project$/ do |pos|
  visit create_projects_url
  within("table > tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following create_projects:$/ do |create_projects|
  create_projects.raw[1..-1].each_with_index do |row, i|
    row.each_with_index do |cell, j|
      response.should have_selector("table > tr:nth-child(#{i+2}) > td:nth-child(#{j+1})") { |td|
        td.inner_text.should == cell
      }
    end
  end
end
