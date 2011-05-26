class Step < ActiveRecord::Base
  # attr_accessible :path_id, :business_process_element_id, :comment
#  validates_presence_of :path_id, :business_process_element_id

	default_scope :order => 'id ASC'

  belongs_to :path
  belongs_to :business_process_element
  belongs_to :iteration
  has_one :bam_to_fam_map, :dependent => :destroy

  has_many :bam_to_fam_features, :dependent => :destroy
#  accepts_nested_attributes_for :bam_to_fam_features

  has_many :features, :through => :bam_to_fam_features

  has_many :watchings, :as => :watchable, :dependent => :destroy

	has_paper_trail

	include Trackable

	include Watchable

	include AASM

	aasm_column :status

	aasm_initial_state :not_mapped

	aasm_state :not_mapped, :success => :unmap_path
  aasm_state :mapped, :success => :map_path
  aasm_state :tested
  aasm_state :enabled

  aasm_event :map, :success => :map_path do
    transitions :to => :mapped, :from => [:not_mapped], :guard => :signed_off_by_all?
  end

  aasm_event :unmap, :success => :unmap_path do
    transitions :to => :not_mapped, :from => [:mapped, :not_mapped]
  end

  aasm_event :test do
    transitions :to => :tested, :from => [:mapped]
  end

  aasm_event :enable do
    transitions :to => :enabled, :from => [:tested]
  end

	def mapping_required?
		BusinessProcessElement::ELEMENT_TYPES[business_process_element.element_type][:mapping_required]
	end

	def mapped?
		self.bam_to_fam_map
	end

	def map_path
		self.path.map!
	end

	def unmap_path
		self.path.unmap!
	end

	def element_type
		BusinessProcessElement::ELEMENT_TYPES[business_process_element.element_type][:display_name]
	end

	def element_name
		business_process_element.name
	end

	def signed_off_by_all?
#		!self.bam_to_fam_map.approvals.find_by_status(["not_approved", "rejected"])
    !self.bam_to_fam_map.approvals.exists?({:status => ["not_approved", "rejected"]})

	end

#	def bam_to_fam_map
#		if !self.bam_to_fam_features.blank?
#			self.bam_to_fam_features[0].bam_to_fam_map
#		else
#			nil
#		end
#	end

	def interested_parties
  	@interested_parties = []
	  @interested_parties << self.watchings.all
	  @interested_parties << self.path.interested_parties
	  @interested_parties.flatten.compact
	end
	
  def deep_clone
    new_step = clone
    new_step.created_at = new_step.updated_at = Time.now
    new_step.bam_to_fam_map = bam_to_fam_map.deep_clone(new_step) if bam_to_fam_map
    new_step.watchings = watchings.collect { |c| c.clone }
    new_step
  end
  
end
