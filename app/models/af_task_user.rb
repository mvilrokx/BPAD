class AfTaskUser < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "task_user"

  belongs_to :task, :class_name => "AfTask", :foreign_key => "tasks_id"
  belongs_to :user, :class_name => "AfUser", :foreign_key => "responsibles_id"

end

