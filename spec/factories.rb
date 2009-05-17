Factory.define :draft_article, :class => Article do |f|
  f.title "My New Article"
  f.content "This is just a test article"
  f.status "draft"
end

Factory.define :active_article, :class => Article do |f|
  f.title "My New Article"
  f.content "This is just a test article"
  f.status "active"
end

Factory.define :user do |f|
  f.login "bob"
  f.name "Bob Bobson"
  f.sequence(:email) { |n| "bob#{n}@example.com"}
  f.password "secret"
  f.password_confirmation { |u| u.password }
  f.state "pending"
  f.sequence(:subdomain) { |n| "#{n}bob" }
end

Factory.define :role do |f|
  f.name "user"
end

Factory.define :profile do |f|
  f.location "London"
  f.phone "07811140700"
  f.web "http://example.com"
  f.date_of_birth "23/09/1983"
end

Factory.define :theme do |f|
  f.name "dark"
  f.background_colour "#1c1c1c"
  f.text_colour "#ffffff"
  f.available true
  f.border_colour "#ffffff"
end

Factory.define :font do |f|
  f.name "Futura"
  f.font_file_name "Futura.swf"
  f.font_file_size 8749
  f.font_content_type "application/x-shockwave-flash"
end