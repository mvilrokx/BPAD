class IssuesController < ApplicationController
  def index
    @issueable = find_issueable
    @issues = @issueable.issues.all
    render :partial => "issue_list", :locals => {:issueable => @issueable, :issues => @issues}
  end

  def show
    @issue = Issue.find(params[:id])
  end

  def new
    @issueable = find_issueable
    @issue = @issueable.issues.new
  end

  def create
    @issueable = find_issueable
    @issue = @issueable.issues.build(params[:issue])
    if @issue.save
      if request.xhr?
        render :json => @issue, :layout => false
      else
        render :nothing => true
#        redirect_to @issue
      end
#      flash[:notice] = "Successfully created issue."
#      redirect_to @issue
    else
      render :action => 'new'
    end
  end

  def edit
    @issueable = find_issueable
    @issue = @issueable.issues.find(params[:id])
  end

  def update
    @issueable = find_issueable
    @issue = @issueable.issues.find(params[:id])
    if @issue.update_attributes(params[:issue])
#      if request.xhr?
        render :json => @issue, :layout => false
#      else
#        redirect_to @issue
#      end
#      flash[:notice] = "Successfully updated issue."
#      redirect_to @issue
    else
      render :action => 'edit'
    end
  end

  def destroy
    @issue = Issue.find(params[:id])
    @issue.destroy
    render :nothing => true
#    flash[:notice] = "Successfully destroyed issue."
#    redirect_to issues_url
  end

  private

    def find_issueable
      params.each do |name, value|
        if name =~ /(.+)_id$/
          return $1.pluralize.classify.constantize.find(value)
        end
      end
      nil
    end
end
