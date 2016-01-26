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

ActiveRecord::Schema.define(version: 20160126024532) do

  create_table "dependencies", force: :cascade do |t|
    t.integer  "question_id"
    t.integer  "response_id"
    t.boolean  "trigger_value"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "dependencies", ["question_id"], name: "index_dependencies_on_question_id"
  add_index "dependencies", ["response_id"], name: "index_dependencies_on_response_id"

  create_table "goals", force: :cascade do |t|
    t.text     "text"
    t.integer  "lesson_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "goals", ["lesson_id"], name: "index_goals_on_lesson_id"
  add_index "goals", ["user_id"], name: "index_goals_on_user_id"

  create_table "lessons", force: :cascade do |t|
    t.date     "date"
    t.integer  "school_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "lessons", ["school_id"], name: "index_lessons_on_school_id"

  create_table "option_templates", force: :cascade do |t|
    t.integer  "response_template_id"
    t.string   "value"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "option_templates", ["response_template_id"], name: "index_option_templates_on_response_template_id"

  create_table "options", force: :cascade do |t|
    t.string   "value"
    t.integer  "response_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "options", ["response_id"], name: "index_options_on_response_id"

  create_table "question_templates", force: :cascade do |t|
    t.string   "text"
    t.boolean  "help_text"
    t.integer  "template_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "question_templates", ["template_id"], name: "index_question_templates_on_template_id"

  create_table "questions", force: :cascade do |t|
    t.string   "text"
    t.string   "help_text"
    t.integer  "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "questions", ["survey_id"], name: "index_questions_on_survey_id"

  create_table "response_templates", force: :cascade do |t|
    t.string   "type"
    t.integer  "question_template_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "response_templates", ["question_template_id"], name: "index_response_templates_on_question_template_id"

  create_table "responses", force: :cascade do |t|
    t.boolean  "boolean_value"
    t.integer  "integer_value"
    t.string   "string_value"
    t.text     "text_value"
    t.integer  "question_id"
    t.integer  "user_id"
    t.string   "type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "responses", ["question_id"], name: "index_responses_on_question_id"
  add_index "responses", ["user_id"], name: "index_responses_on_user_id"

  create_table "schools", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "surveys", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "surveys", ["lesson_id"], name: "index_surveys_on_lesson_id"
  add_index "surveys", ["user_id"], name: "index_surveys_on_user_id"

  create_table "templates", force: :cascade do |t|
    t.boolean  "pre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.boolean  "admin"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.boolean  "activated",                    default: false
    t.datetime "activated_at"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean  "monday",                       default: false
    t.boolean  "tuesday",                      default: false
    t.boolean  "wednesday",                    default: false
    t.boolean  "thursday",                     default: false
    t.boolean  "friday",                       default: false
    t.integer  "phone",             limit: 10
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
