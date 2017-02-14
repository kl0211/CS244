#    http://network-simulator-ns-2.7690.n7.nabble.com/LAR-Patch-td27351.html

BEGIN {
         for (i in send) {
                 send[i] = 0
		 sendt[i] = 0
         }
         for (i in recv) {
                 recv[i] = 0
		 recvt[i] = 0
         }
         delay = 0
         num = 0
         avg_delay = 0
}
{
 # Trace line format: normal
#         if ($2 != "-t") {
#                event = $1
#                time = $2
#                node_id_s = $3
#		node_id_d = $4
#		pkt_type = $5
#		pkt_size = $6
#		pkt_attrib = $7
#                pkt_id = $12
#         }
         # Trace line format: new
         if ($4 == "AGT" || $4 == "RTR") {
                 event = $1
                 time = $2
		 node_id_s = $3
                 node_id_d = $3
                 pkt_type = $7
                 pkt_size = $8
                 flow_id = $5
                 pkt_id = $6
         }
         # Store packets sent
         if (event == "s" && pkt_type == "tcp") {
                 send[pkt_id] = time
		 sendt[pkt_id] = 1
         #        print("send[",pkt_id,"] = ",time)
         }
        
 # Store packets arrival time
         if (event == "r" && pkt_type == "tcp") {
                 recv[pkt_id] = time
		 recvt[pkt_id] = 1
         #        print("recv[",pkt_id,"] = ",time)
         #       print(" --> delay[",pkt_id,"]= ",recv[pkt_id]-send[pkt_id])
        if (recvt[pkt_id] == 1 && sendt[pkt_id] == 1) {
		print (time," ",(recv[pkt_id]-send[pkt_id])) > "wireless.tr" }
        }
}
END {
        # Compute average delay
        for (i in recv) {
                if (sendt[i] == 1 && recvt[i] == 1) {
                     delay += recv[i] - send[i]
                     num ++
                }
	}

        if (num != 0) {
                avg_delay = delay / num
        } else {
                avg_delay = 0
        }
        print("")
        print("")
        print("==> Average delay 2 = ",avg_delay,"s")
        print("                     = ",avg_delay*1000,"ms")
}

