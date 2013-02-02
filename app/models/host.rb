class Host < ActiveRecord::Base
  has_many :ports, :dependent => :destroy
  attr_accessor :ssh_conn

  def support_fetch_hba?
    false
  end

  def assign(info)
    self.type = info['type']
    self.host = info['host']
    self.user = info['user']
    self.pass = info['pass']
  end

  def ssh_connect
    return if @ssh_conn
    @ssh_conn = Net::SSH.start(host, user, :password => pass)
  end

  def exec(cmd)
    ssh_connect
    result = @ssh_conn.exec!(cmd)
    result ? result.strip : ''
  end

  def sed_search(str)
    return "sed -n 's/#{str}\\(.*\\).*/\\1/p'"
  end

  def create_port(dev, wwn, speed)
    p = Port.new
    p.dev = dev
    p.wwn = wwn
    p.speed = speed.to_i
    p.host = self
    p.save
    self.ports << p
    return
  end

  def fetch_hba
    return [] unless support_fetch_hba?

    Port.destroy_all(:host_id => id)
    self.ports = []

    hba_devs = exec(cmd_list_hbas)
    hba_devs.split.each do |dev|
      wwn = exec(cmd_get_wwn(dev))
      speed = exec(cmd_get_speed(dev))
      create_port(dev, wwn, speed)
    end

    return self.ports
  end

  ENTITIES = {
    'aix' => Host::AixHost,
    'hp-ux' => Host::HpuxHost,
    'symmetrix' => Host::SymmetrixHost,
    'brocade' => Host::BrocadeHost
  }

  class << self
    def find_sti_class(type_name)
      ENTITIES[type_name] or Host
    end

    def sti_name(clazz)
      ENTITIES.invert[clazz]
    end
 
    def sti_name
      ENTITIES.invert[self]
    end
  end

end
