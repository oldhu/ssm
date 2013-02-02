class AixHost < Host

  def support_fetch_hba?
    true
  end

  def cmd_list_hbas
    "lsdev -Cc adapter | grep fcs | awk '{print $1}'"
  end

  def cmd_get_wwn(dev)
    "lscfg -vl #{dev} | #{sed_search('Network Address\\.*')}"
  end

  def cmd_get_speed(dev)
    "fcstat #{dev} | #{sed_search('Port Speed (running):')}"
  end
end