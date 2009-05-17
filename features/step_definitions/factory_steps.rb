Given /^the following admins?$/ do |table|
  table.hashes.each do |hash|
    Factory(:theme)
    Factory(:font)
    Factory(:role)
    f = Factory(:user, hash)
    f.activate!
    r = Factory(:role, :name => "admin")
    f.roles << r
    f.save
  end
end

Given /^the following users?$/ do |table|
  table.hashes.each do |hash|
    Factory(:theme)
    Factory(:font)
    Factory(:role)
    f = Factory(:user, hash)
    f.activate!
  end
end

Given /^the following (.+) records?$/ do |record_name, table|
  factory = record_name.singularize.gsub(" ", "_")
  table.hashes.each do |hash|
    f = Factory(factory, hash)
    f.activate! if factory == "user" #setting up a user record
  end
end

