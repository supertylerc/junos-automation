#
# BGP Library
# (c) 2013 Tyler Christiansen
# tylerc@label-switched.net
# BSD 2-Clause License
# http://github.com/tyler-c/junos-automation/
#
require 'junos-ez/stdlib'

class BGP
  def initialize(session)
    @session = session
  end
 
  Neighbor = Struct.new(:id, :as, :description, :state, :up, :tables)

  def get_neighbor(ip)
    Junos::Ez::Facts::Keeper.define(:bgp_neighbor) {
      |session, facts|
      neighbor_facts = ['peer-address', 'peer-as', 'description', 'local-as', 'local-address',
                        'peer-state', 'bgp-option-information/bgp-options', 
                        'bgp-option-information/holdtime', 'nlri-type-peer', 'nlri-type-session',
                        'peer-id']
      neighbor_info = session.rpc.get_bgp_neighbor_information
      neighbors = neighbor_info.xpath('bgp-peer')
      neighbors.each {
        |neighbor|
        next unless neighbor.xpath('peer-address').text =~ /#{ip}/
        facts[:bgp_neighbor] = Hash[neighbor_facts.collect {
          |element|
          [element.gsub(/.*\//, '').tr('-','_').to_sym, neighbor.xpath(element).text]
        }]
      }
    }
    @session.facts.read!
    return @session.facts[:bgp_neighbor]
  end

  def summary
    peers_array = []
    @session.facts.read!
    bgp = @session.rpc.get_bgp_summary_information
    # Group, Peer, and Down counts currently unused.
    # They only need to be exposed for direct access.
    group_count = bgp.xpath('group-count').text
    peer_count = bgp.xpath('peer-count').text
    down_count = bgp.xpath('down-peer-count').text

    peers = bgp.xpath('bgp-peer')
    peers.each {
      |peer|
      tables_array = []
      tables = peer.xpath('bgp-rib')
      tables.each {
        |table|
        table_info = { id: table.xpath('name').text, 
                       received: table.xpath('received-prefix-count').text,
                       accepted: table.xpath('accepted-prefix-count').text,
                       suppressed: table.xpath('suppressed-prefix-count').text,
                       active: table.xpath('active-prefix-count').text
        }
        tables_array << table_info
      }
      peer_info = Neighbor.new(peer.xpath('peer-address').text,
                           peer.xpath('peer-as').text,
                           peer.xpath('description').text,
                           peer.xpath('peer-state').text,
                           peer.xpath('elapsed-time').text,
                           tables_array
      )
      peers_array << peer_info
    }
    return peers_array
  end 
 
  def clear_neighbor(options)
    if options[:soft] == 'in'
      options[:soft] = 'soft-inbound'
    elsif options[:soft] == 'out'
      options[:soft] = 'soft'
    else
      options[:soft] = ''
    end
    if options[:instance]
      options[:instance] = "instance #{options[:instance]}"
    end
    @session.rpc.command "clear bgp neighbor #{options[:ip]} #{options[:soft]} #{options[:instance]}"
  end
  
  def is_up?(ip)
    neighbor = @session.rpc.command "show bgp neighbor #{ip}"
    neighbor.xpath('bgp-peer').xpath('peer-state').text == 'Established' ? (return true) : (return false)
  end
end
