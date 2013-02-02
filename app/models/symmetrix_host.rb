require 'rexml/document'

class SymmetrixHost < Host
  
  def support_fetch_hba?
    true
  end

  def assign(info)
    super(info)
    self.sid = info['sid']
  end

  def exec(cmd)
    cmd = 'PATH=$PATH:/opt/emc/SYMCLI/bin/;export SYMCLI_OUTPUT_MODE=XML_ELEMENT;' + cmd 
    str = super(cmd)
    puts str
    return REXML::Document.new(str)
  end

  def exec_with_sid(sid, cmd)
    return exec("export SYMCLI_SID=#{sid};" + cmd)
  end

  def fetch_symids
    doc = exec('syminq -sym -symmids -wwn')
    symids = []
    doc.elements.each('SymCLI_ML/Inquiry/symid') do |ele|
      symids << ele.text
    end
    puts symids.uniq!
  end

  def fetch_fa_wwns(sid)
    Port.destroy_all(:host_id => id)
    self.ports = []
    doc = exec_with_sid(sid, 'symcfg list -FA ALL')
    doc.elements.each('SymCLI_ML/Symmetrix/Director') do |dir|
      id = dir.text('Dir_Info/id')
      dir.elements.each('Port/Port_Info') do |port|
        dev = "#{id}:#{port.text('port')}"
        wwn = port.text('port_wwn')
        speed = port.text('maximum_speed')
        create_port(dev, wwn, speed)
      end
    end
    self.ports
  end

  def fetch_hba
    fetch_fa_wwns(self.sid)
  end

end