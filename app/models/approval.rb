class Approval < ActiveRecord::Base
  attr_accessible :user_id, :approvable_id, :approvable_type, :status, :approval_date
  belongs_to :user
  belongs_to :approvable, :polymorphic => true

#  APPROVAL_STATUS = %w{new approved rejected}

#  validates_inclusion_of :status, :in => APPROVAL_STATUS

	include AASM

	aasm_column :status

	aasm_initial_state :not_approved

	aasm_state :not_approved
  aasm_state :approved
  aasm_state :rejected

  aasm_event :approve do
    transitions :to => :approved, :on_transition=>:stamp_time, :from => [:not_approved, :approved, :rejected] #, :guard => :signed_off_by_all?
  end

  aasm_event :reject do
    transitions :to => :rejected, :on_transition=>:stamp_time, :from => [:not_approved, :approved, :rejected]
  end

  aasm_event :unapprove do
    transitions :to => :not_approved, :on_transition=>:clear_approval_date, :from => [:rejected, :approved, :not_approved]
  end

  def clear_approval_date
  	self.approval_date = nil
  end

  def stamp_time
    self.approval_date = Time.now
  end

end
