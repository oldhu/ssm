class Zone < ActiveRecord::Base
  has_many :zoneMembers, :dependent => :destroy
  belongs_to :brocadeHost, :foreign_key => "host_id"
end
