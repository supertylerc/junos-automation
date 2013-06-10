#!/usr/bin/ruby

#
# RIB Viewer Example
# (c) 2013 Tyler Christiansen
# tylerc@label-switched.net
# BSD 2-Clause License
#

# Basic configuration needed for feature exploration

require 'junos-ez/stdlib'
require 'net/netconf/jnpr'
require_relative 'lib/settings'
require_relative 'lib/rib'

login = {
      target: ARGV[0],
      username: Settings::CREDENTIALS[:username],
      password: Settings::CREDENTIALS[:password]
}

session = Netconf::SSH.new(login)
session.open
Junos::Ez::Provider(session)
rib = RIB.new(session)
results = rib.get_route(ARGV[1], true)

puts "Destination: #{results[:rt_destination]}
  Table: #{results[:table_name]}"
  puts "  Protocol: #{results[:protocol_name]}"
results[:nh].each {
  |next_hop|
  puts "    Via: #{next_hop}"
}