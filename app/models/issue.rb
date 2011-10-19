class Issue < ActiveRecord::Base
  belongs_to :issueable, :polymorphic => true
  belongs_to :user

  STATUSES = ["Open", "Closed"]
  SEVERITIES = ["Critical", "Non-Critical"]
  TYPES = ["User Interface", "Functional Design", "Technical Design"]

  validates_inclusion_of :status, :in => STATUSES
  validates_inclusion_of :severity, :in => SEVERITIES
  validates_inclusion_of :issue_type, :in => TYPES, :allow_nil => true, :allow_blank => true

end

