class BrocadeHost < Host
  has_many :zones, :foreign_key => "host_id", :dependent => :destroy
  has_many :brocadePorts, :foreign_key => "host_id", :dependent => :destroy

  def load_switch_ports
    lines = exec('switchshow').split("\n")

    self.is_principal = false
    if m = /switchRole:(.*)/.match(lines[4])
      if m[1].strip == 'Principal'
        self.is_principal = true
      end
    end
    if m = /switchDomain:(.*)/.match(lines[5])
      self.domain = m[1].strip
    end

    BrocadePort.destroy_all(:host_id => id)
    self.brocadePorts = []

    lines = lines[13..-1]

    lines.each do |line|
      items = line.split(' ')
      port = BrocadePort.new
      port.index = items[0].to_i
      port.slot = items[1].to_i
      port.port = items[2].to_i
      port.speed = items[5]
      port.state = items[6]
      port.type = items[8] if items.size >= 9
      port.wwn = items[9] if items.size >= 10
      port.brocadeHost = self
      if (port.wwn)
        port.save
        self.brocadePorts << port
      end
    end

    self.save
  end

  def create_zone(zone_name, members)
    zone = Zone.new
    zone.name = zone_name
    zone.brocadeHost = self
    zone.save
    members.each do |m|
      member = ZoneMember.new
      member.zone = zone
      member.member = m
      member.save
      zone.zoneMembers << member
    end
  end

  def load_switch_zones
    return unless self.is_principal
    lines = exec('cfgactvshow').split("\n")

    Zone.destroy_all(:host_id => id)

    started = false
    zone_name = ''
    zone_members = []
    lines.each do |line|
      if !started && line.strip == 'Effective configuration:'
        started = true
        next
      end
      next unless started
      if m = /zone:(.*)/.match(line)
        if zone_name.size > 0 && zone_members.size > 0
          create_zone(zone_name, zone_members)
          zone_members = []
        end
        zone_name = m[1].strip
        next
      end
      zone_members.push(line.strip) if zone_name.size > 0
    end
    if zone_name.size > 0 && zone_members.size > 0
      create_zone(zone_name, zone_members)
    end
  end

end