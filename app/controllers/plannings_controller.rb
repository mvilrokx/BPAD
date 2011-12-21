class PlanningsController < ApplicationController
  def index
    @users = User.all
  end
end

