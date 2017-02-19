# CS244
Computer Networks

Topology:

We have 4 nodes. There are two TCP connections between nodes 1,2 and nodes
3,4. Node 1 sends packets to Node 2, and Node 3 sends packets to Node
4. The 1,2 and 3,4 connections are placed far away from each other enough
so that they should not interfere with each other. That is at least what we
wanted. However, during testing we have noticed that the deterministic
connection has slight variations between test runs. We attribute this to
the wireless nodes being within sensing range, which causes the packet
deliveries to be slightly inconsistent.

Connections:

Each connection works on a FTP application. The 1,2 connection initially
sends packet sizes of 1500, but every second send a random amount between
500 and 5000. This starts at time 1.0 second and lasts for 7 seconds.

The 3,4 connection is always sending packet sizes of 1500 for 7 seconds
from 1.0 second to 8.0 seconds.


Factors for throughput and delay:

There are several factors which affect throughput and delay including:
- packet size
- distance
- link rate
- Wireless technology

We chose for this assignment to keep the distance fixed. We kept the link
rate constant at 1 Mbit/sec while plotting data for throughput and
delay. When plotting the link rate vs delay, we kept the packet size
constant at 1500 bytes and tested rates of 1, 2, 5.5, 11 and 54
Mbit/sec. The wireless technology was left at default (such as a, b, g,
n). We assume that NS2 changed the technology automatically when changing
the link rates.
