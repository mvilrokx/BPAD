class Plan
  attr_accessor :planned_paths

  def initialize(start_date = Date.today.months_since(4).beginning_of_month)

    iteration_start_date = start_date
    assignment_happened = true
    @planned_paths = Hash.new

    unplanned_paths = Path.all(:joins => :users, :group => "id", :order => "priority")
    all_users = User.all
    available_users = all_users.dup

    until unplanned_paths.empty? or !assignment_happened
      assignment_happened = false
      unplanned_paths.each do |path|
        assign_in_this_iteration = true
        path.users.each do |user|
          if !available_users.include?(user)
            assign_in_this_iteration = false
          end
        end

        if assign_in_this_iteration
          assignment_happened = true
          @planned_paths[path] = [iteration_start_date, path.developers.join(',')]
          path.users.each do |user|
            available_users.delete(user)
          end
        end
        break if available_users.empty?
      end
      unplanned_paths.delete_if {|x| @planned_paths.has_key?(x)}
      available_users = all_users.dup
      iteration_start_date = iteration_start_date.next_month
    end
  end

end

