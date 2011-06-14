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

ActiveRecord::Schema.define(:version => 20110613192844) do

  create_table "approvals", :force => true do |t|
    t.integer  "user_id"
    t.integer  "approvable_id"
    t.string   "approvable_type"
    t.string   "status"
    t.datetime "approval_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "approvals", ["approvable_id", "approvable_type"], :name => "approvable_ix"
  add_index "approvals", ["user_id"], :name => "user_id_ix"

  create_table "assignments", :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "assignments", ["role_id"], :name => "role_id_ix"
  add_index "assignments", ["user_id"], :name => "user_id_ix"

  create_table "bam_to_fam_features", :force => true do |t|
    t.integer  "feature_id"
    t.integer  "bam_to_fam_map_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "step_id"
  end

  add_index "bam_to_fam_features", ["bam_to_fam_map_id"], :name => "bam_to_fam_map_id_ix"
  add_index "bam_to_fam_features", ["feature_id"], :name => "feature_id_ix"
  add_index "bam_to_fam_features", ["step_id"], :name => "step_id_ix"

  create_table "bam_to_fam_maps", :force => true do |t|
    t.integer  "step_id"
    t.integer  "functional_work_unit_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
  end

  add_index "bam_to_fam_maps", ["step_id"], :name => "step_id_ix"

  create_table "build_features", :force => true do |t|
    t.string   "name"
    t.integer  "buildable_id"
    t.string   "buildable_type"
    t.text     "description"
    t.integer  "iteration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
  end

  add_index "build_features", ["buildable_id", "buildable_type"], :name => "buildable_ix"

  create_table "business_areas", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
  end

  add_index "business_areas", ["iteration_id"], :name => "iteration_id_ix"
  add_index "business_areas", ["parent_id"], :name => "parent_id_ix"

  create_table "business_process_elements", :force => true do |t|
    t.integer  "business_process_id"
    t.string   "name"
    t.string   "element_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
    t.string   "xml_element_id"
  end

  add_index "business_process_elements", ["business_process_id"], :name => "business_process_id_ix"

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

  add_index "business_processes", ["iteration_id"], :name => "iteration_id_ix"

  create_table "fam_to_tam_maps", :force => true do |t|
    t.integer  "feature_id"
    t.integer  "build_feature_id"
    t.integer  "iteration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "fam_to_tam_maps", ["build_feature_id"], :name => "build_feature_id_ix"
  add_index "fam_to_tam_maps", ["feature_id"], :name => "feature_id_ix"

  create_table "features", :force => true do |t|
    t.integer  "functional_work_unit_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
    t.string   "priority"
    t.string   "scope"
    t.string   "feature_type"
  end

  add_index "features", ["functional_work_unit_id"], :name => "functional_work_unit_id_ix"

  create_table "flows", :force => true do |t|
    t.integer  "business_process_element_id"
    t.integer  "target_element_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
    t.string   "xml_element_id"
  end

  add_index "flows", ["business_process_element_id"], :name => "business_process_element_id_ix"
  add_index "flows", ["target_element_id"], :name => "target_element_id_ix"

  create_table "functional_work_units", :force => true do |t|
    t.string   "name"
    t.integer  "business_area_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
  end

  add_index "functional_work_units", ["business_area_id"], :name => "business_area_id_ix"

  create_table "interfaces", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "lba_id"
    t.integer  "iteration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interfaces", ["lba_id"], :name => "lba_id_ix"

  create_table "issues", :force => true do |t|
    t.string   "name"
    t.integer  "issueable_id"
    t.string   "issueable_type"
    t.text     "description"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issues", ["issueable_id", "issueable_type"], :name => "issueable_ix"

  create_table "iterations", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  create_table "lbas", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "iteration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lbas", ["iteration_id"], :name => "iteration_id_ix"
  add_index "lbas", ["parent_id"], :name => "parent_id_ix"

  create_table "lbos", :force => true do |t|
    t.integer  "business_area_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
    t.string   "description"
  end

  add_index "lbos", ["business_area_id"], :name => "business_area_id_ix"

  create_table "logical_entities", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "lbo_id"
    t.boolean  "datedness"
    t.boolean  "translation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
  end

  add_index "logical_entities", ["lbo_id"], :name => "lbo_id_ix"

  create_table "logical_entity_attributes", :force => true do |t|
    t.string   "name"
    t.boolean  "mandatory"
    t.string   "le_type"
    t.integer  "logical_entity_id"
    t.integer  "iteration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "logical_entity_attributes", ["logical_entity_id"], :name => "logical_entity_id_ix"

  create_table "paths", :force => true do |t|
    t.integer  "business_process_id"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "iteration_id"
    t.string   "status"
    t.integer  "priority"
  end

  add_index "paths", ["business_process_id"], :name => "business_process_id_ix"
  add_index "paths", ["iteration_id"], :name => "iteration_id_ix"

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

  add_index "steps", ["business_process_element_id"], :name => "business_process_element_id_ix"
  add_index "steps", ["iteration_id"], :name => "iteration_id_ix"
  add_index "steps", ["path_id"], :name => "path_id_ix"

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

  add_index "watchings", ["user_id"], :name => "user_id_ix"
  add_index "watchings", ["watchable_id", "watchable_type"], :name => "watchable_ix"

end
