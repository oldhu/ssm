class BrocadePort < ActiveRecord::Base
  belongs_to :brocadeHost, :foreign_key => "host_id"
  set_inheritance_column :zzz_type
end
