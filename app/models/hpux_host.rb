class HpuxHost < Host

  def support_fetch_hba?
    true
  end

  def cmd_list_hbas
    "ls /dev | egrep 'fcd|td|fclp'"
  end

  def cmd_get_wwn(dev)
    "/opt/fcms/bin/fcmsutil /dev/#{dev} | #{sed_search('N_Port Port World Wide Name =')}"
  end

  def cmd_get_speed(dev)
    "/opt/fcms/bin/fcmsutil /dev/#{dev} | #{sed_search('Link Speed =')}"
  end
end
