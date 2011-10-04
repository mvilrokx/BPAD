class WorkAssignmentsController < ApplicationController
  has_many :paths, :through => :users
  def index
    @work_assignments = WorkAssignment.all
  end
end

