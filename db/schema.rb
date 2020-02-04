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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150730174436) do

  create_table "carts", force: :cascade do |t|
    t.text     "courses",       limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cartid",        limit: 255
    t.float    "total_credits", limit: 53
  end

  add_index "carts", ["cartid"], name: "index_carts_on_cartid", using: :btree

  create_table "comments", force: :cascade do |t|
    t.integer  "commentable_id",     limit: 4,     default: 0
    t.string   "commentable_type",   limit: 255,   default: ""
    t.string   "title",              limit: 255,   default: ""
    t.text     "body",               limit: 65535
    t.string   "subject",            limit: 255,   default: ""
    t.integer  "user_id",            limit: 4,     default: 0,        null: false
    t.integer  "parent_id",          limit: 4
    t.integer  "lft",                limit: 4
    t.integer  "rgt",                limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",             limit: 255,   default: "active"
    t.integer  "prev",               limit: 4
    t.integer  "cached_votes_total", limit: 4,     default: 0
    t.integer  "cached_votes_up",    limit: 4,     default: 0
    t.integer  "cached_votes_down",  limit: 4,     default: 0
    t.boolean  "old",                              default: false
  end

  add_index "comments", ["cached_votes_down"], name: "index_comments_on_cached_votes_down", using: :btree
  add_index "comments", ["cached_votes_total"], name: "index_comments_on_cached_votes_total", using: :btree
  add_index "comments", ["cached_votes_up"], name: "index_comments_on_cached_votes_up", using: :btree
  add_index "comments", ["commentable_id"], name: "index_comments_on_commentable_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "dept",              limit: 255
    t.string   "professor",         limit: 255
    t.string   "proficiencies",     limit: 255
    t.string   "building",          limit: 255
    t.string   "room",              limit: 255
    t.string   "cnum",              limit: 255
    t.integer  "crn",               limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "csize",             limit: 4
    t.string   "semester",          limit: 255
    t.integer  "mods",              limit: 1
    t.float    "crmax",             limit: 24
    t.float    "crmin",             limit: 24
    t.time     "start_time"
    t.time     "end_time"
    t.text     "descrip",           limit: 65535
    t.string   "semcrn",            limit: 255
    t.integer  "hubcourse_id",      limit: 4
    t.text     "prereqs",           limit: 65535
    t.string   "short_title",       limit: 255
    t.datetime "last_changed"
    t.integer  "enroll",            limit: 4
    t.boolean  "dean_consent"
    t.boolean  "instruct_consent"
    t.string   "section",           limit: 255
    t.string   "format",            limit: 255
    t.boolean  "std_letter"
    t.boolean  "p_np"
    t.boolean  "cr_ne"
    t.boolean  "audit"
    t.string   "days",              limit: 255
    t.string   "xlist1",            limit: 255
    t.string   "xlist2",            limit: 255
    t.string   "xlist3",            limit: 255
    t.string   "title",             limit: 255
    t.string   "status",            limit: 255,   default: ""
    t.string   "distributions",     limit: 255
    t.string   "dept_long",         limit: 255,   default: ""
    t.string   "xlist1_semcrn",     limit: 255
    t.string   "xlist2_semcrn",     limit: 255
    t.string   "xlist3_semcrn",     limit: 255
    t.string   "full_course",       limit: 255
    t.text     "prof_desc",         limit: 65535
    t.string   "which_desc",        limit: 255
    t.string   "new_desc_action",   limit: 255
    t.text     "prof_note",         limit: 65535
    t.boolean  "display_prof_note",               default: true
    t.string   "notify_profs",      limit: 255
    t.string   "recent_edit",       limit: 255
    t.string   "changed_fields",    limit: 255
  end

  add_index "courses", ["semcrn"], name: "index_courses_on_semcrn", using: :btree

  create_table "courses_professors", id: false, force: :cascade do |t|
    t.integer "course_id",    limit: 4, null: false
    t.integer "professor_id", limit: 4, null: false
  end

  add_index "courses_professors", ["professor_id", "course_id"], name: "index_courses_professors_on_professor_id_and_course_id", unique: true, using: :btree

  create_table "departments", force: :cascade do |t|
    t.string   "dept",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dept_long",  limit: 255
  end

  create_table "departments_professors", id: false, force: :cascade do |t|
    t.integer "professor_id",  limit: 4, null: false
    t.integer "department_id", limit: 4, null: false
  end

  add_index "departments_professors", ["professor_id", "department_id"], name: "index_departments_professors_on_professor_id_and_department_id", unique: true, using: :btree

  create_table "handles", force: :cascade do |t|
    t.string   "username",   limit: 255
    t.boolean  "is_mute",                default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "handlekey",  limit: 255
  end

  add_index "handles", ["handlekey"], name: "index_handles_on_handlekey", unique: true, using: :btree

  create_table "hubcourses", force: :cascade do |t|
    t.string   "hub_id",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "department_id", limit: 4
    t.integer  "cnum",          limit: 4
    t.string   "cname",         limit: 255
  end

  add_index "hubcourses", ["hub_id"], name: "index_hubcourses_on_hub_id", unique: true, using: :btree

  create_table "professors", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",      limit: 255
    t.string   "fname",      limit: 255
    t.string   "lname",      limit: 255
    t.string   "nickname",   limit: 255
    t.string   "status",     limit: 255,   default: "active"
    t.string   "office",     limit: 255
    t.string   "phone",      limit: 255
    t.string   "contact",    limit: 255
    t.string   "url",        limit: 255
    t.text     "content",    limit: 65535
    t.string   "userid",     limit: 255
    t.boolean  "can_edit",                 default: true
    t.string   "my_classes", limit: 255
  end

  create_table "reports", force: :cascade do |t|
    t.string   "title",              limit: 255
    t.text     "body",               limit: 65535
    t.integer  "reportable_id",      limit: 4
    t.string   "reportable_type",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "response",           limit: 65535
    t.string   "admin_email",        limit: 255
    t.boolean  "resolved",                         default: false
    t.integer  "user_id",            limit: 4
    t.text     "reportable_content", limit: 65535
    t.string   "locked_by",          limit: 255
    t.integer  "reported_id",        limit: 4
  end

  create_table "settings", force: :cascade do |t|
    t.string   "key",        limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["key"], name: "index_settings_on_key", using: :btree

  create_table "syllabuses", force: :cascade do |t|
    t.string   "path",       limit: 255
    t.integer  "course_id",  limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "fname",          limit: 255
    t.string   "email",          limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token", limit: 255
    t.string   "status",         limit: 255,   default: "pending"
    t.string   "lname",          limit: 255
    t.string   "role",           limit: 255
    t.string   "nickname",       limit: 255
    t.boolean  "admin",                        default: false
    t.string   "year",           limit: 255
    t.text     "privacy_prefs",  limit: 65535
    t.text     "notes",          limit: 65535
    t.integer  "cart_id",        limit: 4
    t.string   "major",          limit: 255
    t.integer  "prof_id",        limit: 4
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "votable_id",   limit: 4
    t.string   "votable_type", limit: 255
    t.integer  "voter_id",     limit: 4
    t.string   "voter_type",   limit: 255
    t.boolean  "vote_flag"
    t.string   "vote_scope",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vote_weight",  limit: 4
  end

  add_index "votes", ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
  add_index "votes", ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type", using: :btree
  add_index "votes", ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  add_index "votes", ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type", using: :btree

end
