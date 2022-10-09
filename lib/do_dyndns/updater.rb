module DoDyndns
  class Updater
    require 'droplet_kit'

    IPV4_RE = /\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/m
    IPV6_RE = /(?:\:{,2}[A-Z\d]{1,4}\:{,2}){1,8}/im

    def initialize(token:, domains:, ipv4_commands:, ipv6_commands:, logger: Logger.new($stdout))
      @logger = logger
      @domains = domains
      @ipv4_commands = ipv4_commands
      @ipv6_commands = ipv6_commands
      @api = DropletKit::Client.new(access_token: token)
    end

    # Get the domains from DO's API and select only ones specified in the config
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
      resolve(@ipv4_commands, regex: IPV4_RE)
    end

    def wan_ipv6
      resolve(@ipv6_commands, regex: IPV6_RE)
    end

    private

    # Try all the commands until one of them works
    def resolve(commands, regex:)
      _ip = nil
      commands.each do |command|
        result = `#{command}`
        _ip = result[regex]
        break if _ip
      end
      _ip
    end
  end
end
