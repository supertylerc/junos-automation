#!/usr/bin/ruby

#
# BGP Peer Bouncer
# (c) 2013 Tyler Christiansen
# tylerc@label-switched.net
# BSD 2-Clause License
#

# This is only an example of how the BGP
# library can be used.  If you're interested
# in doing more, e-mail me.

require_relative 'lib/bgp'
require_relative 'lib/settings'
require 'junos-ez/stdlib'
require 'net/netconf/jnpr'

login = {
      target: ARGV[0],
      username: Settings::CREDENTIALS[:username],
      password: Settings::CREDENTIALS[:password]
}

session = Netconf::SSH.new(login)
session.open
Junos::Ez::Provider(session)

bgp = BGP.new(session)
clear_options = { ip: ARGV[1], soft: ARGV[2], instance: ARGV[3] } 
bgp.clear_neighbor(clear_options)
