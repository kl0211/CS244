# CS244
## Computer Networks

# Topology:

We have 2 nodes and one 1 access point in a wireless network. Nodes 1 and 2
work in a single-hop fashion and only send data to the access point.

# Connections:

Each TCP connection works on an FTP application. Both connections begin
with 1500 Byte packet sizes. We ran simulations where both use fixed packet
sizes and others where both have a random packet size, changing each
second. The simulation time is 150 seconds.

# Factors for throughput and delay in regards to buffer size:

The buffer determines how many packets can remain in the queue before they
are transmitted, If a buffer is full, no other packets can be
added. Depending on the buffer management scheme, certain packets will be
dropped, such as the last one entered in a DropTail scheme.

With a higher buffer size, fewer packets get dropped, but more packets will
be waiting to be transmitted, so the delay increases. If there are fewer
drops, more packets will arrive at their destination in less time. If there
are buffers that are small and drops do not occur too often, there will be
higher throughput due to less waiting time.

In our simulations, we noticed that buffer sizes of at least 20 experience
no packet drops. As we decrease the buffer size, the throughput increases
as well as the delay until around buffer size of around 16. Then both
throughput and delay decrease at a linear rate until we reach a very small
buffer size of 3. We believe that the higher delays around 16 buffer size
occurs because of the combination of waiting time and
re-transmissions. Smaller buffer sizes than 16 have more transmissions due
to packet drops, but the waiting time is much less, so it would seem that
the waiting time has a greater affect on the total delay than
re-transmitting.

In class, Basem explained that the decrease in delay and throughput after
buffer size 16 was due to the link being saturated. This make sense as the
maximum throughput is reached at 16 buffer size. Then as the buffer size is
increased, we see less delay since there are fewer re-transmissions, which
also causes less throughput.

# Lessons Learned / observations:

- Smaller buffers give less delay, but with a higher drop ratio.

- We wanted to use other queue management solutions, however very few would
  work, or give confusing results. For example, using JoBS throws an error
  when trying to run. Unfortunately, we could not find any helpful
  documentation on how to use it. We also tried using CoDel, but we kept
  getting an compilation error. It would seem that Debian's copy of NS2
  does not have it. Some queues would only give the same results as
  DropTail. others would compile, but not output anything in the trace
  file.
