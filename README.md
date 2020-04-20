# DO-Dyndns

Automatically update DNS records on DigitalOcean to the current IP of the machine running the script.

Finds the wan IPv4 address of the server it's running on and
updates the corresponding DNS records on digital ocean.

This is useful if you don't have a static ip from your ISP.

## Installation
`$ gem install do-dyndns`

## Gemfile

`gem 'do-dyndns', '~> 0.3.0'`

`require 'do_dydns'`

## Usage

```ruby
require 'do_dyndns'

updater = DoDyndns::Updater.new(
  token: '...',
  domains: {
    'example.com' => [
      'subdomain'
    ]
  },
  logger: Logger.new($stdout)
)

updater.update_ips # Updates 'subdomain.example.com' to your current IPv4 address
```

## CLI Configuration
When runninng `do_dyndns`, the updater reads a configuration file:

Configuration is located at:
`~/.config/do-dyndns.yml`

if no config file is found, do-dyndns will create one and open it with your `$EDITOR`

```yaml
:token: your_digital_ocean_token_here
:domains:
  example-domain1.com:
    - example-subdomain1
```

## CLI Usage
```
$ do-dyndns 
I, [2019-03-26T14:39:20.643564 #11387]  INFO -- : Started IP check
I, [2019-03-26T14:39:20.720905 #11387]  INFO -- : Current WAN IP: **.**.**.**
I, [2019-03-26T14:39:21.977426 #11387]  INFO -- : IPs Match for ***.***.***
```

## Automation
Following are examples on how to run this script periodically to update your VPS with the machine's current IP

### Cron:
Check every 15 minutes:

```
*/15 * * * * /path/to/do-dyndns
```


### Launchctl
Check every 15 minutes:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.pixelfaucet.do-dyndns</string>

    <key>WorkingDirectory</key>
    <string>~/</string>

    <key>UserName</key>
    <string>nobody</string>

    <key>ProgramArguments</key>
    <array>
      <string>~/.rvm/wrappers/ruby-2.6.5@do-dyndns</string>
      <string>do-dyndns</string>
    </array>

    <key>StartInterval</key>
    <integer>900</integer>
  </dict>
</plist>
```
