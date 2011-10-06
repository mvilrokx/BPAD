class AfTaskAud < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "tasks_AUD"
	acts_as_reportable

  belongs_to :agilefant_revision, :class_name => "AfAgilefantRevision", :foreign_key => "REV"

end

