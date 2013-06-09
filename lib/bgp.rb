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
end
