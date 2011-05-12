class Issue < ActiveRecord::Base
  attr_accessible :name, :issueable_id, :issueable_type, :description, :status
end
