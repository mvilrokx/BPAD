class AfStory < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "stories"

	acts_as_tree

  belongs_to :backlog, :class_name => "AfBacklog", :foreign_key => "backlog_id"
  has_many :labels, :class_name => "AfLabel", :foreign_key => "story_id"

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
      story = AfStory.first(story.id)
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
      self.backlog_id = AfBacklog.product_backlog_id
    elsif object.instance_of?(BuildFeature)
      self.backlog_id = parent.backlog_id
    end
    ap "Debug = story.backlog_id = #{backlog_id}"
#    self.af_labels_attributes = [{:name => object.class.name.downcase + '.id=' + object.id.to_s,
#                                  :displayName => object.class.name.downcase + '.id=' + object.id.to_s,
#                                  :creator_id => 1,
#                                  :timestamp => Time.now}]
  end

  after_create :audit_create, :add_label

protected
  def audit_create
    audit(AfAgilefantRevision::REVISION_TYPES[:create])
  end

  # !!! WARNING: THIS ONLY WORKS IF YOU DELETE THE FK REFERENCE FROM THE
  # LABEL TABLE TO THE STORY TABLE !!!
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

