class WatchingObserver < ActiveRecord::Observer
	observe :business_process,
	        :business_process_element,
	        :path,
	        :step,
	        :flow,
	        :business_area,
	        :functional_work_unit,
	        :lbo,
	        :logical_entity,
	        :logical_entity_attribute,
	        :interface,
	        :feature

	cattr_accessor :current_user # GLOBAL VARIABLE. RELIES ON RAILS BEING SINGLE THREADED

  def after_create(model)
    watching = model.watchings.new(:user_id => current_user, :creator => true)
    watching.save
  end

  def after_update(model)
    watching = model.watchings.find_or_create_by_user_id(current_user)
    watching.save
  end

end
