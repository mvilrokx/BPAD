class AfUser < ActiveRecord::Base
  establish_connection :agilefant
  set_table_name "users"
end

