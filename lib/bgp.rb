require 'junos-ez/stdlib'

class BGP
  Junos::Ez::Facts::Keeper.define(:bgp) {
    |ndev, facts|
    bgp_info = ndev.rpc.get_bgp_summary_information
    facts[:bgp] = bgp_info.xpath('ospf-neighbor')
  }

  def initialize(session)
    @session = session
  end

  def summary
    output = []
    @session.facts.read!
    bgp = @session.rpc.get_bgp_summary_information
    # Group, Peer, and Down counts currently unused.
    group_count = bgp.xpath('group-count').text
    peer_count = bgp.xpath('peer-count').text
    down_count = bgp.xpath('down-peer-count').text

    peers = bgp.xpath('bgp-peer')
    peers.each {
      |peer|
      peer_info = <<-END
Peer          :  #{peer.xpath('peer-address').text}
  AS          :  #{peer.xpath('peer-as').text}
  Description :  #{peer.xpath('description').text}
  State       :  #{peer.xpath('peer-state').text}
  Up Time     :  #{peer.xpath('elapsed-time').text}
      END
      output << peer_info

      tables = peer.xpath('bgp-rib')
      tables.each {
        |table|
        peer_info = <<-END
  Table       :  #{table.xpath('name').text}
    Received  :  #{table.xpath('received-prefix-count').text}
    Accepted  :  #{table.xpath('accepted-prefix-count').text}
    Rejected  :  #{table.xpath('suppressed-prefix-count').text}
    Active    :  #{table.xpath('active-prefix-count').text}
        END
        output << peer_info
      }
    }
    return output
  end 
end
