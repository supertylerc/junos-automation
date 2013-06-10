#s
# RIB Library
# (c) 2013 Tyler Christiansen
# tylerc@label-switched.net
# BSD 2-Clause License
# http://github.com/tyler-c/junos-automation/
#
require 'junos-ez/stdlib'

class RIB
  def initialize(session)
    @session = session
  end

  def get_route(prefix, exact=false)
    Junos::Ez::Facts::Keeper.define(:route) {
      |session, facts|
      route_facts = ['table-name', 'rt/rt-destination', 'rt/rt-entry/protocol-name']
      cmd = "show route #{prefix}"
      cmd = "show route #{prefix} exact" if exact
      route = session.rpc.command cmd
      route_info = route.xpath('route-table')
      nh_array = []
      next_hops = route_info.xpath('rt/rt-entry')
      next_hops.xpath('nh').each {
        |nh|
        nh_array << "#{nh.xpath('to').text}, via #{nh.xpath('via').text}"
      }
      facts[:route] = Hash[route_facts.collect {
          |element|
          [element.gsub(/.*\//, '').tr('-','_').to_sym, route_info.xpath(element).text]
        }]
      facts[:route][:nh] = nh_array
    }
    @session.facts.read!
    return @session.facts[:route]
  end
end