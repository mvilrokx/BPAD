class Issue < ActiveRecord::Base
  belongs_to :issueable, :polymorphic => true
  belongs_to :user

	has_paper_trail

  STATUSES = ["Open", "Closed"]
  SEVERITIES = ["Critical", "Non-Critical", "Blocking"]
  TYPES = ["User Interface", "Functional Design", "Technical Design", "Techstack ER", "Techstack Bug", "Dependencies", "Integration Issue/Task"]
  SOURCES = ["Demo", "Mapping Review", "Code Review"]

  validates_inclusion_of :status, :in => STATUSES
  validates_inclusion_of :severity, :in => SEVERITIES
  validates_inclusion_of :issue_type, :in => TYPES, :allow_nil => true, :allow_blank => true
  validates_inclusion_of :source, :in => SOURCES, :allow_nil => true, :allow_blank => true

  def owner
    User.find(self.originator) if self.originator
  end

end

