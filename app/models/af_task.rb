class AfTask < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "tasks"
	acts_as_reportable

  belongs_to :story, :class_name => "AfStory", :foreign_key => "story_id"
  has_many :task_users, :class_name => "AfTaskUser", :foreign_key => "tasks_id"
  has_many :users, :through => :task_users

  def developers
    @dev = []
    for user in users
      @dev << user.fullName
    end
    @dev
  end

end

