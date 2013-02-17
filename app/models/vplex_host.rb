require 'net/http'

class VplexHost < Host
  def support_fetch_hba?
    true
  end

  def request_uri(uri)
    req = Net::HTTP::Get.new(uri.request_uri)
    req['username'] = self.user
    req['password'] = self.pass

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.ssl_version = "SSLv3"

    res = http.start do |https|
      https.request(req)
    end
    return res.body
  end

  def request_wwn(uri)
    res = request_uri(uri)
    attributes = ActiveSupport::JSON.decode(res)['response']['context'][0]['attributes']
    attributes.each do |att|
      if att['name'] == 'port-wwn'
        return att['value']
      end
    end
    return ""
  end

  def fetch_hba
    uri = URI("https://#{self.host}/vplex/engines/**/ports")
    res = request_uri(uri)

    Port.destroy_all(:host_id => id)
    self.ports = []

    ActiveSupport::JSON.decode(res)['response']['context'].each do |c|
      children = c['children']
      parent = c['parent']
      next unless children
      director = ""
      if m = /\/engines\/engine-(.*)\/directors\/.*\/hardware/.match(parent)
        director = m[1]
      else
        next
      end
      children.each do |port|
        name = port["name"]
        if port['type'] == 'fc-port'
          uri = URI("https://#{self.host}/vplex#{parent}/ports/#{name}")
          dev = "#{director}-#{port['name']}" 
          wwn = request_wwn(uri)
          create_port(dev, wwn, 0)
        end
      end
    end
    self.ports
  end
end