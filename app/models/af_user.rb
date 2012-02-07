class AfUser < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "users"

  has_many :task_users, :class_name => "AfTaskUser", :foreign_key => "responsibles_id"
  has_many :tasks, :through => :task_users
  has_many :fragments

end

