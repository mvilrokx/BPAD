class AfBacklog < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "backlogs"
	acts_as_tree
	acts_as_reportable

	belongs_to :businessProcess, :class_name => "AfBacklog", :foreign_key => "parent_id"
	has_many :stories, :class_name => "AfStory", :foreign_key => "backlog_id"

	attr_accessor :bpad_business_process_id

  BACKLOG_TYPES = %w{Product Project Iteration}
  validates_inclusion_of :backlogtype, :in => BACKLOG_TYPES

  after_create :audit_create
#  after_update :audit_update
#  after_destroy :audit_destroyfin

  def self.find_from_business_process(business_process)
    AfBacklog.first(:conditions => ["description LIKE ?", "%@@@business_process.id=#{business_process.id}@@@%"])
  end

  def self.find_from_or_create_in_agilefant(business_process)
    backlog = find_from_business_process(business_process)
    if !backlog
      backlog = AfBacklog.new
      backlog.initialize_from_bpad(business_process)
      backlog.save
    end
    backlog
  end

  def self.product_backlog_id(product_backlog = 'Oracle Time and Labor')
    AfBacklog.first(:conditions => ['parent_id is null and name = ?', product_backlog]).id
  end

  def business_process_id
    description.scan(/^@@@business_process.id=(\d+)@@@$/)
  end

  def initialize_from_bpad(business_process, product_backlog = 'Oracle Time and Labor')
    self.name = business_process.name
    self.description = "Created by BPAD! \n\n<< DO NOT CHANGE THE TEXT INBETWEEN THESE ANGLED BRACKETS @@@business_process.id=#{business_process.id}@@@ >>"
    self.parent_id = AfBacklog.first(:conditions => ['parent_id is null and name = ?', product_backlog]).id
    self.backlogtype = self.parent_id ? 'Project' : 'Product'
    self.bpad_business_process_id = business_process.id
    self.backlogSize = 0
    self.baselineLoad = 0
    self.rank = 0
    self.status = 0
    self.startDate = Time.now
    self.endDate = Time.now + 365*24*60*60
#    stories = []
#    for path in business_process.paths do
#      stories << {:name => path.name,
#                  :description => path.description,
#                  :treeRank => path.priority,
#                  :state => AfStory::STORY_STATES[:not_started]}
#    end
#    ap stories
#    self.af_stories_attributes = stories
  end

	def getIterationStartdateMap
		data = AfBacklog.find(:all, :select=>"name, startDate, backlogtype", :conditions => "backlogtype like 'Iteration'")
		iteration_startdate_map = Hash.new
		data.each do |r|
			iteration_startdate_map[r.name] = r.startDate
		end 
		return iteration_startdate_map
	end

	def getProjectIdMap
		data = AfBacklog.find(:all, :select=>"id, name, backlogtype", :conditions => "backlogtype like 'Project'")
		project_id_map = Hash.new
		data.each do |r|
			project_id_map[r.id] = r.name
		end
		return project_id_map
	end

protected

  def audit_create
    audit(AfAgilefantRevision::REVISION_TYPES[:create])
  end

  def audit(type)
    @agilefant_revision = AfAgilefantRevision.create(
      :timestamp => (Time.now.to_f*1000).to_i,
      :userId => 1,
      :userName => 'Administrator')
    @backlog_aud = @agilefant_revision.backlog_auds.new(
      :REVTYPE => type,
      # :id => id, #This doesn't work, you HAVE to assign the id manually
      :parent_id => parent_id,
      :name => name,
      :description => description,
      :backlogSize => backlogSize,
      :baselineLoad => baselineLoad,
      :startDate => startDate,
      :endDate => endDate,
      :rank => rank,
      :status => status,
      :backlogtype => backlogtype
       );
    @backlog_aud.id = id
    @backlog_aud.save
  end
end

