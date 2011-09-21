class Tagging < ActiveRecord::Base
  belongs_to :path
  belongs_to :tag 
end
