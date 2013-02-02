class FabricController < ApplicationController
  def index
    @zones = Zone.all
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def reload
    hosts = BrocadeHost.all
    hosts.each do |host|
      host.load_switch_ports
      host.load_switch_zones
    end
    respond_to do |format|
      format.html { redirect_to fabric_url }
    end
  end

  def host
    host = Host.find(params[:id])
    wwns = []
    host.ports.each do |port|
      wwns << port.wwn
    end
    @zones = Zone.joins(:zoneMembers).where('zone_members.member' => wwns).uniq
    @message = "Zones that have #{host.name} #{host.host}"
    respond_to do |format|
      format.html { render 'index' }
    end
  end

end
