class IssuesController < ApplicationController
  layout :choose_layout
  before_filter :find_issueable

  def index
    @issues = @issueable.issues.all
  end

  def show
    @issue = Issue.find(params[:id])
  end

  def new
    @issue = @issueable.issues.new
  end

  def create
    @issue = @issueable.issues.build(params[:issue])
    if @issue.save
      flash[:notice] = "Successfully added issue."
      redirect_to [@issueable, :issues]
    else
      render :action => 'new'
    end
  end

  def edit
    @issue = @issueable.issues.find(params[:id])
  end

  def update
    @issue = @issueable.issues.find(params[:id])
    if @issue.update_attributes(params[:issue])
      flash[:notice] = "Successfully updated issue."
      redirect_to [@issueable, :issues]
    else
      render :action => 'edit'
    end
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issueable = @issue.issueable
    @issue.destroy
    flash[:notice] = "Successfully destroyed issue."
    redirect_to [@issueable, :issues]
  end

  private

    def find_issueable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          @issueable =  $1.pluralize.classify.constantize.find(value)
        end
      end
      nil
    end

  def choose_layout
    (request.xhr?) ? nil : 'issues'
  end
end

