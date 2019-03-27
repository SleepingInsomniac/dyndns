module Dyndns
  class Updater
    require 'droplet_kit'

    def initialize(token:, domains:, logger: Logger.new($stdout))
      @logger = logger
      @domains = domains
      @api = DropletKit::Client.new(access_token: token)
    end

    # Get the domains from DO's API and selecto only ones specified in the config
    def domains
      @api.domains
        .all
        .select{ |d| @domains.keys.include? d.name }
    end

    # Get the config specified sub domains for a domain
    # - param {DropletKit::Domain} domain - The domain object
    def sub_domains_for(domain)
      @api.domain_records
        .all(for_domain: domain.name)
        .select{ |r| r.type == "A" && @domains[domain.name].include?(r.name) }
    end

    # Check if a record ip differs from your current ip
    # - param {DropletKit::DomainRecord} record - A domain record
    def ip_changed?(record)
      raise "Cannot determine WAN IPv4" unless _ip = wan_ipv4
      record.data != _ip
    end

    # Calls update on all configured domain's subdomains
    def update_ips
      @logger.info "Started IP check"
      @logger.info "Current WAN IP: #{wan_ipv4}"

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

    # Update the associated domain with the current WAN IPv4 address
    # - param {DropletKit::Domain} domain - The domain object
    # - param {DropletKit::DomainRecord} record - A domain record
    def update(domain, record)
      @logger.info "Updating record #{record.name}.#{domain.name} from #{record.data} to #{wan_ipv4}"
      record.data = wan_ipv4
      @api.domain_records.update(record, for_domain: domain.name, id: record.id)
    end

    def wan_ipv4
      resolve([
        "dig -4 @resolver1.opendns.com ANY myip.opendns.com +short",
        "dig -4 @ns1-1.akamaitech.net ANY whoami.akamai.net +short",
        "dig -4 @ns1.google.com ANY o-o.myaddr.l.google.com +short"
      ])
    end

    def wan_ipv6
      resolve([
        "dig -6 @resolver1.opendns.com ANY myip.opendns.com +short",
        "dig -6 @ns1.google.com ANY o-o.myaddr.l.google.com +short"
      ])
    end

    private

    def resolve(commands)
      _ip = nil
      commands.each do |service|
        _ip = `#{service}`.chomp.gsub(/[^a-z0-9\:\.]/i, '')
        _ip = _ip and break unless _ip.empty?
      end
      _ip.empty? ? nil : _ip
    end
  end
end