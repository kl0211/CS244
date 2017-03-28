# CS244
## Computer Networks

# Topology:

We have 8 nodes and one 1 access point in a wireless network. Nodes 1-8
work in a single-hop fashion and only send data to the access point.

# Connections:

Each connection works on a FTP application. The odd numbered nodes
(1,3,5,7) use random packet sizes which changes between 500 and 5000 bytes
every second during the simulation. Even nodes (2,4,6,8) use the default
packet size of 1500 for the entire simulation. The simulation time is 150
seconds.

# Factors for throughput and delay:

There are several factors which affect throughput and delay including:
- packet size
- distance
- link rate
- Wireless technology
- Transmission Power

# Lessons Learned / obesrvations:

- Higher transmission power enables nodes that are further away to connect
  to an access point

- As more nodes participate in exchanging packets with the access point,
  throughput increases

- However, the delay also increases as the transmission power goes up. This
  is due to the fact that as more nodes participate, the overall delay
  increases since the queueing time at the single access point will
  increase up to the maximum allowed by the buffer.

- There is also more contention in the wireless channel when more nodes are
  in transmission range. This saturates the throughput and increases delay.

- Given our topology, we observed that increasing the transmission power
  above 5mW is unnecessary, given that nodes are within 50 meters. We
  observe that 5mW adequately services these nodes with an insignificant
  increase in delay.

- If there is a small amount of mobile nodes, than there is no need to
  transmit at maximum power. If more nodes try to connect to the access
  point, then there will be more contention, which causes less throughput
  and higher delays. Increasing the transmission power will not solve this
  problem. So it is best to keep the number of expected nodes small, and to
  keep the transmission power as low as needed to service them in the
  minimum expected range.
