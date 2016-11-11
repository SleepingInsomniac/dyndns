module Dyndns
  class Updater
    
    require 'droplet_kit'
    
    def initialize(token:, domains:, sub_domains:, logger: Logger.new($stdout))
      @logger = logger
      throw "Cannot determine WAN IP" unless wan_ip
      @domains = domains
      @sub_domains = sub_domains
      @api = DropletKit::Client.new(access_token: token)
    end

    def domains
      @api.domains
        .all
        .select{ |d| @domains.include? d.name }
    end

    def sub_domains_for(domain)
      @api.domain_records
        .all(for_domain: domain.name)
        .select{ |r| r.type == "A" && @sub_domains.include?(r.name) }
    end

    def ip_changed?(record)
      record.data != wan_ip
    end

    def update_ips
      @logger.info "Started IP check"
      @logger.info "Current WAN IP: #{wan_ip}"

      domains.each do |domain|
        sub_domains_for(domain).each do |record|
          if ip_changed?(record)
            @logger.info "IPs Differ for #{record.name}.#{domain.name}"
            update(domain, record)
          else
            @logger.info "IPs Match for #{record.name}.#{domain.name}"
          end
        end
      end
    end

    def update(domain, record)
      @logger.info "Updating record #{record.name}.#{domain.name} from #{record.data} to #{wan_ip}"
      record.data = wan_ip
      @api.domain_records.update(record, for_domain: domain.name, id: record.id)
    end

    private

    def wan_ip
      @ip ||= `curl -s ip.alexc.link`.chomp[/(\d+\.){3}\d+/]
    end
  end
end