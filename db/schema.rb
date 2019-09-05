# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150730174436) do

  create_table "attachments", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cart_pages", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "carts", :force => true do |t|
    t.text     "courses",       :limit => 16777215
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "cartid"
    t.float    "total_credits"
  end

  add_index "carts", ["cartid"], :name => "index_carts_on_cartid"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",     :default => 0
    t.string   "commentable_type",   :default => ""
    t.string   "title",              :default => ""
    t.text     "body"
    t.string   "subject",            :default => ""
    t.integer  "user_id",            :default => 0,        :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.string   "status",             :default => "active"
    t.integer  "prev"
    t.integer  "cached_votes_total", :default => 0
    t.integer  "cached_votes_up",    :default => 0
    t.integer  "cached_votes_down",  :default => 0
    t.boolean  "old",                :default => false
  end

  add_index "comments", ["cached_votes_down"], :name => "index_comments_on_cached_votes_down"
  add_index "comments", ["cached_votes_total"], :name => "index_comments_on_cached_votes_total"
  add_index "comments", ["cached_votes_up"], :name => "index_comments_on_cached_votes_up"
  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "courses", :force => true do |t|
    t.string   "dept"
    t.string   "professor"
    t.string   "proficiencies"
    t.string   "building"
    t.string   "room"
    t.string   "cnum",                           :default => ""
    t.integer  "crn"
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
    t.integer  "csize"
    t.string   "semester"
    t.integer  "mods",              :limit => 1
    t.float    "crmax"
    t.float    "crmin"
    t.time     "start_time"
    t.time     "end_time"
    t.text     "descrip"
    t.string   "semcrn"
    t.integer  "hubcourse_id"
    t.text     "prereqs"
    t.string   "short_title"
    t.datetime "last_changed"
    t.integer  "enroll"
    t.boolean  "dean_consent"
    t.boolean  "instruct_consent"
    t.string   "section"
    t.string   "format"
    t.boolean  "std_letter"
    t.boolean  "p_np"
    t.boolean  "cr_ne"
    t.boolean  "audit"
    t.string   "days"
    t.string   "xlist1"
    t.string   "xlist2"
    t.string   "xlist3"
    t.string   "title"
    t.string   "status",                         :default => ""
    t.string   "distributions"
    t.string   "dept_long",                      :default => ""
    t.string   "full_course"
    t.string   "xlist1_semcrn"
    t.string   "xlist2_semcrn"
    t.string   "xlist3_semcrn"
    t.text     "prof_desc"
    t.string   "which_desc"
    t.string   "new_desc_action"
    t.text     "prof_note"
    t.boolean  "display_prof_note",              :default => true
    t.string   "notify_profs"
    t.string   "recent_edit"
    t.string   "changed_fields"
  end

  add_index "courses", ["semcrn"], :name => "index_courses_on_semcrn"

  create_table "courses_professors", :id => false, :force => true do |t|
    t.integer "course_id",    :null => false
    t.integer "professor_id", :null => false
  end

  add_index "courses_professors", ["professor_id", "course_id"], :name => "index_courses_professors_on_professor_id_and_course_id", :unique => true

  create_table "departments", :force => true do |t|
    t.string   "dept"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "dept_long"
  end

  create_table "departments_professors", :id => false, :force => true do |t|
    t.integer "professor_id",  :null => false
    t.integer "department_id", :null => false
  end

  add_index "departments_professors", ["professor_id", "department_id"], :name => "index_departments_professors_on_professor_id_and_department_id", :unique => true

  create_table "handles", :force => true do |t|
    t.string   "username"
    t.boolean  "is_mute",    :default => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "handlekey"
  end

  add_index "handles", ["handlekey"], :name => "index_handles_on_handlekey", :unique => true

  create_table "hubcourses", :force => true do |t|
    t.string   "hub_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "department_id"
    t.integer  "cnum"
    t.string   "cname"
  end

  add_index "hubcourses", ["hub_id"], :name => "index_hubcourses_on_hub_id", :unique => true

  create_table "professors", :force => true do |t|
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "email"
    t.string   "fname"
    t.string   "lname"
    t.string   "nickname"
    t.string   "status",     :default => "active"
    t.string   "office"
    t.string   "phone"
    t.string   "contact"
    t.string   "url"
    t.text     "content"
    t.string   "userid"
    t.boolean  "can_edit",   :default => true
    t.string   "my_classes"
  end

  create_table "reports", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "reportable_id"
    t.string   "reportable_type"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.text     "response"
    t.string   "admin_email"
    t.boolean  "resolved",           :default => false
    t.integer  "user_id"
    t.text     "reportable_content"
    t.string   "locked_by"
    t.integer  "reported_id"
  end

  create_table "settings", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "settings", ["key"], :name => "index_settings_on_key"

  create_table "syllabuses", :force => true do |t|
    t.string   "path"
    t.integer  "course_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "fname"
    t.string   "email"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "remember_token"
    t.string   "status",         :default => "pending"
    t.string   "lname"
    t.string   "role"
    t.string   "nickname"
    t.boolean  "admin",          :default => false
    t.string   "year"
    t.text     "notes"
    t.text     "privacy_prefs"
    t.integer  "cart_id"
    t.string   "second_major"
    t.string   "double_major"
    t.string   "major"
    t.integer  "prof_id"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "votes", :force => true do |t|
    t.integer  "votable_id"
    t.string   "votable_type"
    t.integer  "voter_id"
    t.string   "voter_type"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "vote_weight"
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], :name => "index_votes_on_votable_id_and_votable_type_and_vote_scope"
  add_index "votes", ["votable_id", "votable_type"], :name => "index_votes_on_votable_id_and_votable_type"
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], :name => "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  add_index "votes", ["voter_id", "voter_type"], :name => "index_votes_on_voter_id_and_voter_type"

end
