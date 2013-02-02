module ApplicationHelper

  def host_name_by_wwn(wwn)
    port = Port.find_by_wwn(wwn)
    if (port)
      return "#{port.host.name}, #{port.dev}"
    else
      return ""
    end
  end

  def wwn_online_state(wwn)
    port = BrocadePort.find_by_wwn(wwn)
    if (port)
      return "X"
    else
      return "."
    end
  end
end
