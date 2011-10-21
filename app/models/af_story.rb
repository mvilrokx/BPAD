class AfStory < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "stories"

	acts_as_tree

  belongs_to :backlog, :class_name => "AfBacklog", :foreign_key => "backlog_id"
	belongs_to :usecase, :class_name => "AfStory", :foreign_key => "parent_id"
  has_many :labels, :class_name => "AfLabel", :foreign_key => "story_id"
  has_many :tasks, :class_name => "AfTask", :foreign_key => "story_id"

  accepts_nested_attributes_for :labels

  attr_accessor :bpad_object

  STORY_STATES = {:not_started  => 0,
                  :started      => 1,
                  :pending      => 2,
                  :blocked      => 3,
                  :ready        => 4,
                  :done         => 5}

  validates_inclusion_of :state, :in => STORY_STATES.values

  def self.find_from_bpad_object(object)
    if object.instance_of?(Path)
      condition = ["labels.name = ?", "path.id=#{object.id}"]
    elsif object.instance_of?(BuildFeature)
      condition = ["labels.name = ?", "build_feature.id=#{object.id}"]
    end
    story = AfStory.first(:joins => :labels,  :conditions => condition)
  end

  def self.find_from_or_create_in_agilefant(object, parent = nil)
    story = find_from_bpad_object(object)
    if !story
      if parent
        story = parent.children.new
      else
        story = AfStory.new
      end
      story.initialize_from_bpad(object, parent)
      story.save
    else
      # This is to avoid a READONLY issue caused by using :join in previous select
      story = AfStory.find(story.id)
    end
    story
  end

  def path_id
    labels.first.scan(/^path.id=(\d+)/)
  end

  def build_feature_id
    labels.first.scan(/^build_feature.id=(\d+)/)
  end

  def initialize_from_bpad(object, parent = nil)
    self.bpad_object = object
    self.name = object.name
    self.description = object.description
    self.state = STORY_STATES[:not_started]
    if object.instance_of?(Path)
      self.treeRank = object.priority||0
      self.backlog_id = AfBacklog.product_backlog_id unless backlog && backlog.backlogtype == 'Iteration'
    elsif object.instance_of?(BuildFeature)
      self.backlog_id = parent.backlog_id unless backlog && backlog.backlogtype == 'Iteration'
    end
#    self.af_labels_attributes = [{:name => object.class.name.downcase + '.id=' + object.id.to_s,
#                                  :displayName => object.class.name.downcase + '.id=' + object.id.to_s,
#                                  :creator_id => 1,
#                                  :timestamp => Time.now}]
  end

	def getUsecaseNames
		data = AfStory.find(:all, :select=>"id, name, backlog_id", :conditions => "parent_id is null")
		id_name_map = Hash.new
		data.each do |r|
			id_name_map[r.id] = r.name
		end
		return id_name_map
	end

	def getUsecasenameProjectUasecaseIdMap
		usecase_id_name_map = getUsecaseNames
		afBacklog = AfBacklog.new 
		project_id_map = afBacklog.getProjectIdMap
		data = AfStory.find(:all, :select=>"id, name, backlog_id", :conditions => "parent_id is null")
		rlt = Hash.new 
		data.each do |r|
			usecase = r.name
			project = project_id_map[r.backlog_id]
			usecase_id = r.id 
			key = Array.new 
			key << usecase
			key << project 
			rlt[key] = usecase_id
		end 
		return rlt
	end 

  after_create :audit_create, :add_label

  def original_estimate
    estimate = 0
    self.children.each do |sub_story|
      estimate = estimate + sub_story.tasks.sum("originalestimate")
    end
    estimate
  end

	def getUsecaseStoryMap
		story_usecase_data = AfStory.find(:all, :select=>"id, parent_id", :conditions=>"parent_id is not null")
		usecase_story_hash = Hash.new 
		story_usecase_data.each do |r|
			usecase_id = r.parent_id
			story_id  = r.id 
			if(usecase_story_hash[usecase_id].nil?)
				story_array = Array.new 
				story_array << story_id 
				usecase_story_hash[usecase_id] = story_array
			else
				story_array = usecase_story_hash[usecase_id]
				story_array << story_id 
				usecase_story_hash[usecase_id] = story_array
			end 
		end 
		return usecase_story_hash
	end 

	def getIterationProjectUsecaseMap
		usecase_project_data = AfStory.find(:all, :select=>"id, backlog_id", :conditions=>"parent_id is null")
		usecase_project_hash = Hash.new
		usecase_project_data.each do |r|
			project_id = r.backlog_id 
			usecase_id = r.id 
			usecase_project_hash[usecase_id] = project_id
		end
		story_usecase_data = AfStory.find(:all, :select=>"id, parent_id, backlog_id", :conditions=>"parent_id is not null")
		iter_project_usecase_hash = Hash.new
		story_usecase_data.each do |r|
			iteration_id = r.backlog_id
			usecase_id = r.parent_id 
			project_id = usecase_project_hash[usecase_id]
			if(iter_project_usecase_hash[iteration_id].nil?)
				iter_project_hash = Hash.new 
				usecase_array = Array.new 
				usecase_array << usecase_id 
				iter_project_hash[project_id] = usecase_array 
				iter_project_usecase_hash[iteration_id] = iter_project_hash
			else
				iter_project_hash = iter_project_usecase_hash[iteration_id]
				if(iter_project_hash.nil?)
					usecase_array = Array.new 
					usecase_array << usecase_id
					iter_project_hash[project_id] = usecase_array
				else
					usecase_array = iter_project_hash[project_id]
					usecase_array << usecase_id
					iter_project_hash[project_id] = usecase_array
				end
				iter_project_usecase_hash[iteration_id] = iter_project_hash
			end
		end 
		return iter_project_usecase_hash
	end 

	def getCurrentStoryIdBacklogIdMap(story_array)
		data = AfStoryAud.find(:all, :select=>"id, backlog_id", :conditions => ["id IN (?)", story_array])
		rlt = Hash.new 
		data.each do |r|
			rlt[r.id] = r.backlog_id
		end 
		return rlt
	end 

protected

  def audit_create
    audit(AfAgilefantRevision::REVISION_TYPES[:create])
  end

  # !!! WARNING: THIS ONLY WORKS IF YOU DELETE THE FK REFERENCE FROM THE
  # AGILEFANT LABEL TABLE TO THE STORY TABLE !!!
  def add_label
    @label = AfLabel.new(:name => bpad_object.class.name.underscore + '.id=' + bpad_object.id.to_s,
                         :displayName => bpad_object.class.name.underscore + '.id=' + bpad_object.id.to_s,
                         :creator_id => 1,
                         :timestamp => Time.now)

    @label.story_id = id
    @label.save
  end

  def audit(type)
    @agilefant_revision = AfAgilefantRevision.create(
      :timestamp => (Time.now.to_f*1000).to_i,
      :userId => 1,
      :userName => 'Administrator')
    @story_aud = @agilefant_revision.story_auds.new(
      :REVTYPE => type,
      # :id => id, #This doesn't work, you HAVE to assign the id manually
      :parent_id => parent_id,
      :name => name,
      :description => description,
      :state => state,
      :storyPoints => storyPoints,
      :treeRank => treeRank,
      :backlog_id => backlog_id)
    @story_aud.id = id
    @story_aud.save
  end

end

