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

ActiveRecord::Schema.define(:version => 20110422012212) do

  create_table "approvals", :force => true do |t|
    t.integer  "user_id"
    t.integer  "approvable_id"
    t.string   "approvable_type"
    t.string   "status"
    t.datetime "approval_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assignments", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "bam_to_fam_features", :force => true do |t|
    t.integer  "feature_id"
    t.integer  "bam_to_fam_map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "step_id"
  end

  create_table "bam_to_fam_maps", :force => true do |t|
    t.integer  "step_id"
    t.integer  "functional_work_unit_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
  end

  create_table "business_areas", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
  end

  create_table "business_process_elements", :force => true do |t|
    t.integer  "business_process_id"
    t.string   "name"
    t.string   "element_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
    t.string   "xml_element_id"
  end

  create_table "business_processes", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bpmn_file_name"
    t.string   "bpmn_content_type"
    t.integer  "bpmn_file_size"
    t.datetime "bpmn_updated_at"
    t.integer  "iteration_id"
    t.string   "priority"
  end

  create_table "features", :force => true do |t|
    t.integer  "functional_work_unit_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
    t.string   "priority"
    t.string   "scope"
  end

  create_table "flows", :force => true do |t|
    t.integer  "business_process_element_id"
    t.integer  "target_element_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
    t.string   "xml_element_id"
  end

  create_table "functional_work_units", :force => true do |t|
    t.string   "name"
    t.integer  "business_area_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
  end

  create_table "iterations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "lbos", :force => true do |t|
    t.integer  "business_area_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
  end

  create_table "paths", :force => true do |t|
    t.integer  "business_process_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
    t.string   "status"
    t.string   "priority"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "steps", :force => true do |t|
    t.integer  "path_id"
    t.integer  "business_process_element_id"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
    t.string   "status"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "watchings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "watchable_id"
    t.string   "watchable_type"
    t.boolean  "creator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
