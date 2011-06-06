# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

	def sortable(objects, column, title = nil)
		if objects.size != 0 then
    	title ||= column.titleize
  	  css_class = column == sort_column(objects[0].class) ? "current #{sort_direction}" : nil
    	direction = column == sort_column(objects[0].class) && sort_direction == "asc" ? "desc" : "asc"
  	  link_to title, {:sort_by => column, :direction => direction}, {:class => css_class}
  	end
	end

	def status_iconifier(status, show_text_status = true)
		status||="not_mapped"
		status_text = status.humanize if show_text_status
		case status
			when "not_mapped"
				image = '/icons/bullet_red.png'
			when "mapped"
				image = '/icons/bullet_green.png'
			when "not_approved"
				image = '/icons/new.png'
			when "approved"
				image = '/icons/tick.png'
			when "rejected"
				image = '/icons/cross.png'
			else
				"Unknown"
		end
		image_tag(image, :alt=> status.humanize, :title => status.humanize, :class=>"align_icon_with_text") + status_text.to_s
	end


	def action(user, action, *objects)
    action_image_tags = { :edit           => { :enabled   => '/icons/pencil.png',
                                               :disabled  => '/icons/pencil_disabled.png' },
                          :show           => { :enabled   => '/icons/magnifier.png'},
                          :show_mappings  => { :enabled   => '/icons/table_relationship.png'},
                          :duplicate      => { :enabled   => '/icons/page_copy.png'},
                          :delete         => { :enabled   => '/icons/bin_closed.png',
                                               :disabled  => '/icons/bin_closed_disabled.png',
                                               :mouseover => '/icons/bin.png'},
                          :paths          => { :enabled   => '/icons/arrow_switch.png',
                                               :disabled  => '/icons/arrow_switch_disabled.png',
                                               :mouseover => '/icons/arrow_switch_bluegreen.png'},
                        }

    options = {:title => action}
    if action == :delete
      options[:confirm] = 'Are you sure?'
      options[:method] = :delete
      ap options
    end

    if action == :edit || action == :duplicate
      link = polymorphic_path(objects, :action=>action)
    else
      link = objects
    end
    if user.iteration == objects[0].iteration || objects[0].iteration.nil?
    	link_to(image_tag(action_image_tags[action][:enabled],
    	                   :mouseover => (action_image_tags[action][:mouseover] if action_image_tags[action][:mouseover]),
    	                   :alt=> action),
    	         link,
               options)
    else
	  	image_tag(action_image_tags[action][:disabled], :alt=> action + "Disabled", :title=> action + 'Disabled. This object is being modified in another iteration.')
	  end
	end

	def watching(object, user)
 	  if object.watchings.find_by_user_id(user.id)
      link_to "", [object, object.watchings.find_by_user_id(user.id)], :title=> 'Click to remove from watchlist', :class => "watching remove"
    else
      link_to "", [object, Watching.new], :title=> 'Click to add to watchlist', :class => "watching add"
	  end
	end

  def pretty_date_time(dt, tz = "Pacific Time (US & Canada)", format = "%d-%b-%Y %H:%M")
    dt.in_time_zone(tz).strftime(format)
  end

end

