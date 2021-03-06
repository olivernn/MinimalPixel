# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090829130910) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id",           :null => false
    t.integer  "plan_id",           :null => false
    t.date     "next_payment_date"
    t.string   "status",            :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "profile_id"
  end

  add_index "accounts", ["plan_id"], :name => "index_accounts_on_plan_id"
  add_index "accounts", ["user_id"], :name => "index_accounts_on_user_id"

  create_table "articles", :force => true do |t|
    t.string   "title",      :null => false
    t.text     "content"
    t.string   "permalink",  :null => false
    t.string   "status",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["permalink"], :name => "index_articles_on_permalink"
  add_index "articles", ["status"], :name => "index_articles_on_status"

  create_table "comments", :force => true do |t|
    t.integer  "article_id",                           :null => false
    t.string   "name",       :default => "Annonymous", :null => false
    t.text     "content",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["article_id"], :name => "index_comments_on_article_id"

  create_table "fonts", :force => true do |t|
    t.string   "name",              :null => false
    t.string   "font_file_name"
    t.string   "font_content_type"
    t.integer  "font_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "project_id",          :null => false
    t.integer  "position",            :null => false
    t.string   "name",                :null => false
    t.text     "description"
    t.date     "date"
    t.string   "source_file_name"
    t.string   "source_content_type"
    t.integer  "source_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",                :null => false
    t.string   "status"
  end

  add_index "items", ["position"], :name => "index_items_on_position"
  add_index "items", ["project_id"], :name => "index_items_on_project_id"
  add_index "items", ["status"], :name => "index_items_on_status"
  add_index "items", ["type"], :name => "index_items_on_type"

  create_table "open_id_authentication_associations", :force => true do |t|
    t.integer "issued"
    t.integer "lifetime"
    t.string  "handle"
    t.string  "assoc_type"
    t.binary  "server_url"
    t.binary  "secret"
  end

  create_table "open_id_authentication_nonces", :force => true do |t|
    t.integer "timestamp",  :null => false
    t.string  "server_url"
    t.string  "salt",       :null => false
  end

  create_table "pages", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.string   "title",      :null => false
    t.string   "permalink",  :null => false
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pages", ["permalink"], :name => "index_pages_on_permalink"
  add_index "pages", ["user_id"], :name => "index_pages_on_user_id"

  create_table "passwords", :force => true do |t|
    t.integer  "user_id"
    t.string   "reset_code"
    t.datetime "expiration_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string   "name",              :null => false
    t.integer  "price",             :null => false
    t.string   "payment_frequency", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "available",         :null => false
    t.integer  "project_limit",     :null => false
    t.integer  "image_limit",       :null => false
    t.integer  "video_limit",       :null => false
    t.text     "description"
    t.boolean  "facebook_default"
  end

  add_index "plans", ["available"], :name => "index_plans_on_available"
  add_index "plans", ["name"], :name => "index_plans_on_name"

  create_table "profiles", :force => true do |t|
    t.integer  "user_id",            :null => false
    t.string   "location"
    t.string   "phone"
    t.string   "web"
    t.date     "date_of_birth"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "projects", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.string   "name",        :limit => 100, :null => false
    t.text     "description"
    t.date     "date"
    t.string   "status",                     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["name"], :name => "index_projects_on_name"
  add_index "projects", ["status"], :name => "index_projects_on_status"
  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "questions", :force => true do |t|
    t.string   "question",   :null => false
    t.text     "answer",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string "name"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "styles", :force => true do |t|
    t.integer  "user_id"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.string   "border_type",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "theme_id",          :null => false
    t.integer  "font_id",           :null => false
    t.text     "palette",           :null => false
  end

  add_index "styles", ["font_id"], :name => "index_styles_on_font_id"
  add_index "styles", ["theme_id"], :name => "index_styles_on_theme_id"
  add_index "styles", ["user_id"], :name => "index_styles_on_user_id"

  create_table "themes", :force => true do |t|
    t.string   "name",                                 :null => false
    t.string   "background_colour",                    :null => false
    t.string   "border_colour",                        :null => false
    t.boolean  "available",         :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "text_colour"
  end

  create_table "transactions", :force => true do |t|
    t.integer  "account_id",                                              :null => false
    t.string   "status"
    t.date     "date"
    t.integer  "amount",     :limit => 10, :precision => 10, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "transactions", ["account_id"], :name => "index_transactions_on_account_id"
  add_index "transactions", ["status"], :name => "index_transactions_on_status"

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "identity_url"
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token",            :limit => 40
    t.string   "activation_code",           :limit => 40
    t.string   "state",                                    :default => "passive", :null => false
    t.datetime "remember_token_expires_at"
    t.datetime "activated_at"
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subdomain",                                                       :null => false
    t.integer  "fb_user_id",                :limit => 8
    t.string   "email_hash"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["subdomain"], :name => "index_users_on_subdomain"

end
