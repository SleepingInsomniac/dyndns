# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'do_dyndns/version'

Gem::Specification.new do |spec|
  spec.name          = "do-dyndns"
  spec.version       = DoDyndns::VERSION
  spec.authors       = ["Alex Clink"]
  spec.email         = ["alexclink@gmail.com"]

  spec.summary       = "Automatically update DNS records on DigitalOcean"
  spec.description   = <<~DESC
    Finds the wan IPv4 address of the server it's running on and
    updates the corresponding DNS records on digital ocean.
  DESC
  spec.homepage      = "http://alexclink.com/gems/dyndns"
  spec.license       = "UNLICENSED"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = [
    "lib/**/*",
    "bin/**/*",
    "README.md",
    "config.example.yml"
  ].map { |g| Dir.glob(g) }.flatten
  spec.bindir        = "bin"
  spec.executables   = ['do_dyndns']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  
  spec.add_dependency "droplet_kit"
end
