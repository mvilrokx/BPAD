class WorkAssignmentsController < ApplicationController
  def index
    @work_assignments = WorkAssignment.all
  end
end

