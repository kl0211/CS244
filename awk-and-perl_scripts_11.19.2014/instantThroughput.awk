BEGIN {
	recv = 0
	currTime = prevTime = 0
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

	# Calculate total received packets' size
	if (level == "AGT" && flow_id == flow && node_id == dst &&
	    event == "r" && pkt_size >= pkt) {
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
