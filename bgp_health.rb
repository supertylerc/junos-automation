#!/usr/bin/ruby

#
# BGP Health Check
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

File.open(Settings::FILES[:routers], 'r') {
  |rtrs|
  while (rtr = rtrs.gets)
    rtr = rtr.chomp
    login = {
          target: rtr,
          username: Settings::CREDENTIALS[:username],
          password: Settings::CREDENTIALS[:password]
    }

    session = Netconf::SSH.new(login)
    session.open
    Junos::Ez::Provider(session)

    bgp = BGP.new(session)
    results = bgp.summary
    File.open(Settings::FILES[:log], 'a') {
      |f|
      f.write("Router: #{rtr}\n")
      f.write("========================\n")
      results.each {
        |peer|
        f.write(
"Peer          :  #{peer[:id]}
  AS          :  #{peer[:as]}
  Description :  #{peer[:description]}
  State       :  #{peer[:state]}
  Up Time     :  #{peer[:up]}\n"
        )
        peer[:tables].each {
          |table|
          f.write(
"  Table       :  #{table[:id]}
    Received  :  #{table[:received]}
    Accepted  :  #{table[:accepted]}
    Rejected  :  #{table[:suppressed]}
    Active    :  #{table[:active]}\n"
          )
        }
      }
      f.write("\n\n")
    }
  end
}
