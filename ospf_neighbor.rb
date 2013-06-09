#!/usr/bin/ruby

#
# OSPF Neighbor Info
# (c) 2013 Tyler Christiansen
# tylerc@label-switched.net
# BSD 2-Clause License
#

# This is only an example of how the OSPF
# library can be used.  If you're interested
# in doing more, e-mail me.

require_relative 'lib/ospf'
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

ospf = OSPF.new(session)
neighbor = ospf.get_neighbor(ARGV[1])
puts "Neighbor      : #{neighbor[:neighbor_id]}
  State       : #{neighbor[:ospf_neighbor_state]}
  Up Time     : #{neighbor[:neighbor_up_time]}
  Interface   : #{neighbor[:interface_name]}
    Remote IP : #{neighbor[:neighbor_address]}
    Area      : #{neighbor[:ospf_area]}
  DR          : #{neighbor[:dr_address]}
  BDR         : #{neighbor[:bdr_address]}"
