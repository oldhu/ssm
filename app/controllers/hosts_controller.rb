require 'yaml'

class HostsController < ApplicationController
  # GET /hosts
  # GET /hosts.json
  def index
    @hosts = Host.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @hosts }
    end
  end

  # GET /hosts/reload
  def reload
    hosts_hash = YAML.load_file('config/hosts.yml')['hosts']
    Host.destroy_all
    hosts_hash.keys.each do |key|
      info = hosts_hash[key]
      host = Host.find_sti_class(info['type']).new
      host.name = key
      host.assign(info)
      host.save
    end
    @hosts = Host.all
    respond_to do |format|
      format.html { redirect_to hosts_url }
    end
  end

  def hosts_json_for_fetching_hba
    hosts = []
    Host.all.each do |host|      
      hosts.push({ :id => host.id, :name => host.name }) if host.support_fetch_hba?
    end
    { :data => hosts }
  end

  def ports_to_json(ports)
    { :data => ports }
  end

  # GET /hosts/fetch_hba
  def fetch_hba
    id = params[:id]
    if id
      host = Host.find(id)
      ports = []
      ports = host.fetch_hba if host.support_fetch_hba? 
      respond_to do |format|
        format.json { render json: ports_to_json(ports) }
      end
    else
      respond_to do |format|
        format.json { render json: hosts_json_for_fetching_hba }
        format.js
      end
    end
  end

end