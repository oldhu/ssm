class Port < ActiveRecord::Base
  belongs_to :host

  def wwn=(value)
    raise "wwn not valid" unless value.size >= 16
    v = value[-16, 16].downcase
    self[:wwn] = "#{v[0, 2]}:#{v[2, 2]}:#{v[4, 2]}:#{v[6, 2]}:#{v[8, 2]}:#{v[10, 2]}:#{v[12, 2]}:#{v[14, 2]}"  	
  end

end
