#!/usr/bin/ruby

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

    File.open(Settings::FILES[:log], 'w') {
      |f|
      results.each {
        |peer|
        f.write(peer)
      }
    }
  end
}
