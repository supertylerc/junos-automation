#
# OSPF Library
# (c) 2013 Tyler Christiansen
# tylerc@label-switched.net
# BSD 2-Clause License
# http://github.com/tyler-c/junos-automation/
#
require 'junos-ez/stdlib'

class OSPF
  def initialize(session)
    @session = session
  end

  def get_neighbor(ip)
    Junos::Ez::Facts::Keeper.define(:ospf) {
      |session, facts|
      neighbor_facts = ['neighbor-address', 'interface-name', 'ospf-neighbor-state',
                        'neighbor-id', 'ospf-area', 'neighbor-up-time', 'dr-address',
                        'bdr-address']
      neighbor_info = session.rpc.command "show ospf neighbor detail"
      neighbors = neighbor_info.xpath('ospf-neighbor')
      neighbors.each {
        |neighbor|
        next unless neighbor.xpath('neighbor-id').text =~ /#{ip}/
        facts[:ospf_neighbor] = Hash[neighbor_facts.collect {
          |element|
          [element.tr('-','_').to_sym, neighbor.xpath(element).text.gsub(/\n+/, '')]
        }]
      }
    }
    @session.facts.read!
    return @session.facts[:ospf_neighbor]
  end
  
  def get_summary
    
  end
  
  def is_up?(ip)
    state = @session.rpc.command "show ospf neighbor #{ip}"
    state.xpath('ospf-neighbor').empty? ? return false : return true
  end
end
