class Iteration < ActiveRecord::Base
  before_destroy :check_for_children

	include AASM

	aasm_column :status

	aasm_initial_state :open

	aasm_state :open
  aasm_state :closed

  aasm_event :close do
    transitions :to => :closed, :from => [:open], :guard => :ok_to_close
  end

  attr_accessible :name, :status

  has_many :users, :dependent => :nullify
  has_many :business_processes
  has_many :business_process_elements
  has_many :paths

  def ok_to_close
  	true
 	end

	scope :active, where(:status => "open")

	class InUse < StandardError
  end

    private

    def check_for_children
	    puts "TEST"
#      if business_processes.count > 0 || business_process_elements.count > 0 || paths.count > 0
        raise InUse unless business_processes.count == 0 && business_process_elements.count == 0 && paths.count == 0
#      end
    end

end

