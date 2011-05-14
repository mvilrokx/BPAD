class Issue < ActiveRecord::Base
  belongs_to :issueable, :polymorphic => true
  
  STATUSES = ["Open", "Closed"]

  validates_inclusion_of :status, :in => STATUSES

end
