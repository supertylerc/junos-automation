#!/usr/bin/ruby

#
# BGP Neighbor Info
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
neighbor = bgp.get_neighbor(ARGV[1])
puts "Neighbor      : #{neighbor[:peer_id]}
  Peer ASN    : #{neighbor[:peer_as]}
  Description : #{neighbor[:description]}
  State       : #{neighbor[:peer_state]}
  Holdtime    : #{neighbor[:holdtime]}
  Options     : #{neighbor[:bgp_options]}
  NLRIs       : #{neighbor[:nlri_type_session]}"
