# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dyndns/version'

Gem::Specification.new do |spec|
  spec.name          = "dyndns"
  spec.version       = Dyndns::VERSION
  spec.authors       = ["Alex Clink"]
  spec.email         = ["alex@certedrive.com"]

  spec.summary       = "Update dns records on DigitalOcean Droplets"
  spec.description   = "The summary is pretty much all there is to say."
  spec.homepage      = "http://git.pixelfaucet.com/alex/dyndns"
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
    "dyndns.yml"
  ].map {|g| Dir.glob(g)}.flatten
  spec.bindir        = "bin"
  spec.executables   = ['dyndns']
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  
  spec.add_dependency "droplet_kit"
end
