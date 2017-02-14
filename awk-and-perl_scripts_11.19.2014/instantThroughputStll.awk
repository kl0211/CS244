#Author: Marco Fiore
#little changes I've made are indicated



BEGIN {
	recv = 0
	currTime = prevTime = 0
        min=2; max=20; # Changed: I use this to calculate the flow from node2 to node20 (cause my base station and my rnc are nodes 0 and 1)
	#variables to calculate the RTT
	#tcpsend = ackrecv = RTT = conta = seqtcp = seqack = 0

	printf("# %10s %10s %5s %5s %15s %18s\n\n", \
	       "flow","flowType","src","dst","time","throughput")
}

{
	# Trace line format: normal
	if ($2 != "-t") {
		event = $1
		time = $2
		if (event == "+" || event == "-") node_id = $3
		if (event == "r" || event == "d") node_id = $4
		flow_id = $8
		pkt_id = $12
		pkt_size = $6
		flow_t = $5
		level = "AGT"
		pkt_name= $5 #Changed: I use it to count only one type of packet.
                
	}
	# Trace line format: new
	if ($2 == "-t") {
		event = $1
		time = $3
		node_id = $5
		flow_id = $39
		pkt_id = $41
		pkt_size = $37
		flow_t = $45
		level = $19

	}

	# Init prevTime to the first packet recv time
	if(prevTime == 0)
		prevTime = time



	# Calculates the total number of packets
	# I use node_id to indicate which flows I want to check (in this case all of the ues)
       # I use the condition: (pkt_name == "AM_Data") only to select a kind of packet from the bs to all the ues, so I calculate the throughput. 
	if ((level == "AGT") &&  (event == "r") && (node_id >= min ) && (node_id <= max) && (pkt_size >= pkt) && (pkt_name == "AM_Data")) {


		# Rip off the header
		hdr_size = pkt_size % pkt
		pkt_size -= hdr_size
		# Store received packet's size
		recv += pkt_size
		# This 'if' is introduce to obtain clearer
		# plots from the output of this script


		if((time - prevTime) >= tic*10) {
			printf("  %10g %10s %5d %5d %15g %18g\n", \
				flow,flow_t,src,dst,(prevTime+1.0),0)
			printf("  %10g %10s %5d %5d %15g %18g\n", \
				flow,flow_t,src,dst,(time-1.0),0)
		}
		currTime += (time - prevTime)
		if (currTime >= tic) {
			printf("  %10g %10s %5d %5d %15g %18g\n", \
			       flow,flow_t,src,dst,time,(recv/currTime)*(8/1000))
			recv = 0
			currTime = 0
		}
		prevTime = time
	}
	

}

END {
	printf("\n\n")
}
