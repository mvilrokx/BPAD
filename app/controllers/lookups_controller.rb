class LookupsController < ApplicationController
  # GET /lookups
  # GET /lookups.xml

  def index
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lookups }
    end
  end

  def show
     id = params[:id]
     if id == "tagsvvo"
       tagsvvo
     elsif id == "developersVVo"
       developersVVo
     end

  end

  ## tags Dynamic lookup search
  def tagsvvo
    #@tags = Tag.all
    #sql = "select id , name from tags  where name like " +  "'%#{params[:q]}%'" + " union select -1, " + "'#{params[:q]}'" + " from dual "
    #@tags = Tag.find_by_sql( sql)
    #@tags =        Tag.where("name like ?","%#{params[:q]}%").select(['name', 'id'])
    @tags = Tag.find(:all, :conditions => ["name like ?"  ,"%#{params[:q]}%"])
    results = @tags.map(&:attributes)
    results << {:name => "Add: #{params[:q]}", :id => "CREATE_#{params[:q]}_END"}

    respond_to do |format|
      format.html
      format.json { render :json => results }
      #format.json { render :json => @tags.map(&:attributes) }
    end
  end



  ## Developers/users Dynamic lookup search
  def developersVVo
    var=  "'%#{params[:q]}%'"
    sql = "select id, IFNULL ( CONCAT (name,  ' ', last_Name   )  , CONCAT ('Usre Name: ' , username   )) name from users where name like " + var + " or last_name like " + var + " or username like " + var
    @alldevs = User.find_by_sql(sql  )
    respond_to do |format|
      format.html
      format.json { render :json => @alldevs.map(&:attributes) }
    end
  end





  ## end of lookup
end

