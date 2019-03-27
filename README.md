# DO-Dyndns

Automatically update DNS records on DigitalOcean

Finds the wan IPv4 address of the server it's running on and
updates the corresponding DNS records on digital ocean.

## Installation
`$ gem install do-dyndns`

## Configuration
Configuration is located at:
`~/.config/dyndns.yml`

if no config file is found, do-dyndns will create one and open it with your `$EDITOR`

```yaml
:token: your_digital_ocean_token_here
:domains:
  example-domain1.com:
    - example-subdomain1
```

## Usage
```
$ dyndns 
I, [2019-03-26T14:39:20.643564 #11387]  INFO -- : Started IP check
I, [2019-03-26T14:39:20.720905 #11387]  INFO -- : Current WAN IP: **.**.**.**
I, [2019-03-26T14:39:21.977426 #11387]  INFO -- : IPs Match for ***.***.***
```

## Automation

### Cron:
Check every 15 minutes:

```
*/15 * * * * dyndns
```
