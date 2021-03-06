class Path < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings

  has_many :work_assignments, :dependent => :destroy
  has_many :users, :through => :work_assignments

  has_many :issues, :as => :issueable, :dependent => :destroy
  
  has_many :fragments

  # attr_accessible :business_process_id, :name, :description, :steps_attributes
  validates_presence_of :name, :description
  before_save :set_priority, :unless => :priority

  #attr_writer :tag_names
  #after_save :assign_tags
  
  attr_accessor :lastTagOccurance

  attr_reader :fbstyle_tag_tokens
  after_save :assign_fbstyle_tags

  attr_reader :fbstyle_devloper_tokens
  after_save :assign_work_assginments

  STATUSES = ["Placeholder", "Detailing", "Detailed", "Mapped", "Building", "Built", "Ready for QA", "Demoed", "In QA", "QA Passed", "QA Failed", "QA Blocked", "QA Failed - Regressed"]
  validates_inclusion_of :life_cycle_status, :in => STATUSES, :allow_nil => true, :allow_blank => true

  def fbstyle_tag_tokens=(ids)
    @all_defined_tags =  tags.find_by_sql("select id , name from tags")
    @all_fbstyle_tag_tokens = ids
  end


  def fbstyle_devloper_tokens=(ids)
#    @all_defined_devloper =  WorkAssignment.find(:all)
    @all_fbstyle_devloper_tokens = ids
  end


  belongs_to :business_process
  belongs_to :iteration
  has_many :watchings, :as => :watchable, :dependent => :destroy

  has_many :steps, :dependent => :destroy
  accepts_nested_attributes_for :steps, :allow_destroy => true

	has_paper_trail :ignore => [:name]

	include Trackable

  cattr_reader :per_page
  @@per_page = 30

  PRIORITY = ["1", "2", "3", "4", "5"]
#  validates_inclusion_of :priority, :in => PRIORITY

	include AASM

	aasm_column :status

	aasm_initial_state :not_mapped

#	aasm_state :placeholder
#	aasm_state :detailed
#	aasm_state :building
#	aasm_state :built
#	aasm_state :demoed
#	aasm_state :ready_for_qa
#	aasm_state :in_qa
#	aasm_state :completed

	aasm_state :not_mapped
  aasm_state :mapped
  aasm_state :tested
  aasm_state :enabled

  aasm_event :map do
    transitions :to => :mapped, :from => [:not_mapped], :guard => :all_steps_mapped?
  end

  aasm_event :unmap do
    transitions :to => :not_mapped, :from => [:mapped, :not_mapped]
  end

  aasm_event :test do
    transitions :to => :tested, :from => [:mapped]
  end

  aasm_event :enable do
    transitions :to => :eabled, :from => [:tested]
  end

  def completed?
  	@last_step = self.steps.all(:joins => :business_process_element, :conditions => 'business_process_elements.element_type = "endEvent"')
  	@completed = @last_step.empty? ? false : true
  end

  def all_steps_mapped?
    steps.all(:conditions => {:status => 'not_mapped'}).each do |unmapped_step|
      ap unmapped_step
      if unmapped_step.mapping_required?
       puts "Mapping Required!"
       return false
      end
    end
    return true

#    !self.steps.exists?(:status => 'not_mapped')
  end

	def interested_parties
  	@interested_parties = []
	  @interested_parties << self.watchings.all
	  @interested_parties << self.business_process.interested_parties
	  @interested_parties.flatten.compact
	end

  def deep_clone
    new_path = clone
    new_path.created_at = new_path.updated_at = Time.now
    new_path.name = name + '-copy'
    new_path.steps = steps.collect { |c| c.deep_clone }
#    new_path.watchings = watchings.collect { |c| c.clone }
    new_path
  end

	def non_approvers
	  @non_approvers = []
	  for step in steps
  	  for approval in step.approvals.flatten.compact
   	    @non_approvers << approval.user if approval[:status] == 'not_approved'
  	  end
	  end
	  @non_approvers.uniq{|x| x}
  end

	def features
	  @features = []
	  for step in steps
   	    @features << step.features
	  end
	  @features.flatten
  end

	def build_features
	  @build_features = []
	  for step in steps
  	  for feature in step.features
   	    @build_features << feature.build_features
  	  end
	  end
	  @build_features.flatten
  end

	def exists_in_agilefant?
	  AfStory.find_from_bpad_object(self)
  end

  alias_method :agilefant_story, :exists_in_agilefant?

	def percent_complete
	  if exists_in_agilefant?
      path_story_oe = path_story_el = 0
      agilefant_story.children(:include => :tasks).each do |bf_story|
          bf_story.tasks.each do |task|
          path_story_oe = path_story_oe + (task.originalestimate||0)
          path_story_el = path_story_el + (task.effortleft||0)
        end
      end
      return ((path_story_oe - path_story_el)/path_story_oe.to_f)*100
    else
      return 0
    end
  end

  def developers
    @dev = []
    for user in users
      @dev << user.username
    end
    @dev
  end

  def last_step
    Step.find_by_id(steps.maximum("id"))
  end

  def self.next_available_priority
    Path.maximum("priority") + 1
  end

  def self.tagged_as(tag)
    joins(:tags).where('tags.name = ?', tag)
  end

  private

  #def assign_tags
   # if @tag_names
      #self.tags = @tag_names.split(/\s+/).map do |name|
       # Tag.find_or_create_by_name(name)
      #end
     #end
  #end

  def assign_fbstyle_tags

    if @all_fbstyle_tag_tokens
      ta = @all_fbstyle_tag_tokens.split(",").each{|t|t.strip!}
      adt = {}    #hash all defined tags
      @all_defined_tags.each do |r |
           adt[r.id] = r.name
      end

      a_names = []
      if ta
        ta.each do |t |
          if t =~ (/CREATE_(.+?)_END/)
            t.gsub!(/CREATE_(.+?)_END/) do
              a_names << $1
            end
          else
             ti = t.to_i
             nm = adt[ti]
             a_names << nm
          end
        end

        self.tags = a_names.map do |name|
          Tag.find_or_create_by_name(name)
        end

      end

    end
  end

  def set_priority
    self.priority = Path.next_available_priority
  end

  def assign_work_assginments
    if @all_fbstyle_devloper_tokens
       self.work_assignments = @all_fbstyle_devloper_tokens.split(",").map do |id|
        WorkAssignment.find_or_create_by_user_id(id)
      end
    end
  end


end

