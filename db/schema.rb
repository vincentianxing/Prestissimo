# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_21_213312) do

  create_table "ahoy_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.json "properties"
    t.timestamp "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_visits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.timestamp "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "attachments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cart_pages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "carts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.text "courses", size: :medium
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cartid"
    t.float "total_credits", limit: 53
    t.index ["cartid"], name: "index_carts_on_cartid"
  end

  create_table "comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "commentable_id", default: 0
    t.string "commentable_type", default: ""
    t.string "title", default: ""
    t.text "body"
    t.string "subject", default: ""
    t.integer "user_id", default: 0, null: false
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.integer "prev"
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.boolean "old", default: false
    t.index ["cached_votes_down"], name: "index_comments_on_cached_votes_down"
    t.index ["cached_votes_total"], name: "index_comments_on_cached_votes_total"
    t.index ["cached_votes_up"], name: "index_comments_on_cached_votes_up"
    t.index ["commentable_id"], name: "index_comments_on_commentable_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "courses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "dept"
    t.string "professor"
    t.string "proficiencies"
    t.string "building"
    t.string "room"
    t.string "cnum", default: ""
    t.integer "crn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "csize"
    t.string "semester"
    t.integer "mods", limit: 1
    t.float "crmax"
    t.float "crmin"
    t.time "start_time"
    t.time "end_time"
    t.text "descrip"
    t.string "semcrn"
    t.integer "hubcourse_id"
    t.text "prereqs"
    t.string "short_title"
    t.datetime "last_changed"
    t.integer "enroll"
    t.boolean "dean_consent"
    t.boolean "instruct_consent"
    t.string "section"
    t.string "format"
    t.boolean "std_letter"
    t.boolean "p_np"
    t.boolean "cr_ne"
    t.boolean "audit"
    t.string "days"
    t.string "xlist1"
    t.string "xlist2"
    t.string "xlist3"
    t.string "title"
    t.string "status", default: ""
    t.string "distributions"
    t.string "dept_long", default: ""
    t.string "full_course"
    t.string "xlist1_semcrn"
    t.string "xlist2_semcrn"
    t.string "xlist3_semcrn"
    t.text "prof_desc"
    t.string "which_desc"
    t.string "new_desc_action"
    t.text "prof_note"
    t.boolean "display_prof_note", default: true
    t.string "notify_profs"
    t.string "recent_edit"
    t.string "changed_fields"
    t.index ["semcrn"], name: "index_courses_on_semcrn"
  end

  create_table "courses_professors", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "professor_id", null: false
    t.index ["professor_id", "course_id"], name: "index_courses_professors_on_professor_id_and_course_id", unique: true
  end

  create_table "departments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "dept"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dept_long"
  end

  create_table "departments_professors", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "professor_id", null: false
    t.integer "department_id", null: false
    t.index ["professor_id", "department_id"], name: "index_departments_professors_on_professor_id_and_department_id", unique: true
  end

  create_table "handles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "username"
    t.boolean "is_mute", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "handlekey"
    t.index ["handlekey"], name: "index_handles_on_handlekey", unique: true
  end

  create_table "hubcourses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "hub_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "department_id"
    t.integer "cnum"
    t.string "cname"
    t.index ["hub_id"], name: "index_hubcourses_on_hub_id", unique: true
  end

  create_table "professors", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "fname"
    t.string "lname"
    t.string "nickname"
    t.string "status", default: "active"
    t.string "office"
    t.string "phone"
    t.string "contact"
    t.string "url"
    t.text "content"
    t.string "userid"
    t.boolean "can_edit", default: true
    t.string "my_classes"
  end

  create_table "reports", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.integer "reportable_id"
    t.string "reportable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "response"
    t.string "admin_email"
    t.boolean "resolved", default: false
    t.integer "user_id"
    t.text "reportable_content"
    t.string "locked_by"
    t.integer "reported_id"
  end

  create_table "settings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "key"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_settings_on_key"
  end

  create_table "syllabuses", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "path"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.string "fname"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_token"
    t.string "status", default: "pending"
    t.string "lname"
    t.string "role"
    t.string "nickname"
    t.boolean "admin", default: false
    t.string "year"
    t.text "notes"
    t.text "privacy_prefs"
    t.integer "cart_id"
    t.string "second_major"
    t.string "double_major"
    t.string "major"
    t.integer "prof_id"
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "votes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci", force: :cascade do |t|
    t.integer "votable_id"
    t.string "votable_type"
    t.integer "voter_id"
    t.string "voter_type"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vote_weight"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_id", "votable_type"], name: "index_votes_on_votable_id_and_votable_type"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_id", "voter_type"], name: "index_votes_on_voter_id_and_voter_type"
  end

end
