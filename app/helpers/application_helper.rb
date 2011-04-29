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

end
