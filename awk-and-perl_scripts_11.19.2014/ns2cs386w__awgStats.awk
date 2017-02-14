# http://code.google.com/p/ns2cs386w/source/browse/trunk/trace2stats/avgStats.awk?r=5

BEGIN {
        recvdSize = 0
        startTime = 1e6
        stopTime = 0
        recvs = 0
        sends = 0
seqno = -1
droppedPackets = 0
receivedPackets = 0
#sendpkts=0
#recvpkts=0

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
        # http://www.isi.edu/nsnam/ns/doc/node186.html
        if ($2 == "-t") {
                event = $1
                time = $3
                node_id = $5
                flow_id = $39
                pkt_id = $41
                pkt_seq_no = $47
                pkt_size = $37
                flow_t = $45
                level = $19
                dest_id = $33
                src_id = $31
#printf("time: %s packet sz: %s  flow_id: %s  flow_t: %s  level: %s  dest_id: %s  src_id: %s event: %s\n",time,pkt_size,flow_id,flow_t, level,dest_id,src_id,event)
        }

        # CALCULATE PACKET DELIVERY FRACTION
#       if (( event == "s") &&  ( $35 == "cbr" ) && ( $19=="AGT" )) {  sends++; }
#       if (( event == "r") &&  ( $35 == "cbr" ) && ( $19=="AGT" ))   {  recvs++; }
        if (( src_id == src ) && ( event == "s") && ( level == "AGT" ) && ( pkt_size >= pkt ) && ( flow_id == flow )) {  sends++; sendpkts[pkt_id]++;}
        if (( dest_id == dst ) && ( event == "r") &&  ( level == "AGT" ) && ( pkt_size >= pkt ) && ( flow_id == flow ))   {  recvs++; recvpkts[pkt_id]++;}

if(( src_id == src ) && ( pkt_size >= pkt ) && ( flow_id == flow ) && level == "AGT" && event == "s" && seqno < pkt_seq_no) {

          seqno = pkt_seq_no;

    } else if(( dest_id == dst ) && ( event == "r") &&  ( level == "AGT" ) && ( pkt_size >= pkt ) && ( flow_id == flow )) {

            receivedPackets++;

    } else if (( src_id == src ) && ( event == "d") &&  ( level == "AGT" ) && ( pkt_size >= pkt ) && ( flow_id == flow )){

            droppedPackets++;            

  }



        # Store packets send time
        if (level == "AGT" && flow_id == flow && src_id == src &&
            sendTime[pkt_id] == 0 && (event == "+" || event == "s") && pkt_size >= pkt) {
#printf("storing packet send time     time = %s node_id: %s flow_id: %s pkt_id: %s\n",time,node_id,flow_id,pkt_id)
                if (time < startTime) {
                        startTime = time
                }
                sendTime[pkt_id] = time
                this_flow = flow_t
        }

        # Update total received packets' size and store packets arrival time
        if (level == "AGT" && flow_id == flow && dest_id == dst &&
            event == "r" && pkt_size >= pkt) {
#printf("storing packet recv time     time = %s node_id: %s flow_id: %s pkt_id: %s\n",time,node_id,flow_id,pkt_id)
                if (time > stopTime) {
                        stopTime = time
                }
                # Rip off the header
                hdr_size = pkt_size % pkt
                pkt_size -= hdr_size
                # Store received packet's size
                recvdSize += pkt_size
                # Store packet's reception time
                recvTime[pkt_id] = time
                if (sendTime[pkt_id] == 0)
                        printf("recvd packet that wasn't sent pkt_id: %s  time: %s\n\n",pkt_id,time)
        }

}

END {
print "\n";

    print "GeneratedPackets            = " seqno+1;
    print "PacketSequence              = " seqno;
    print "Sends                       = " sends;
    print "Recvs                       = " recvs;

    print "ReceivedPackets             = " receivedPackets;

    print "Packet Delivery Ratio      = " receivedPackets/(seqno+1)*100
"%";

    print "Total Dropped MANET Packets = " droppedPackets;

    print "Average End-to-End Delay    = " n_to_n_delay * 1000 " ms";

    print "\n";

for (i in sendpkts) {
 if (sendpkts[i] > 1)
        printf("pkt_id: %s  count: %s\n",i,sendpkts[i])
}

#               for (j in recvdPkts) {
# printf("recvdPkts[%s]: %s\n",i,recvdPkts[i])
#               }
        # compute loss %
#       lostPkts = 0
#       for (i in sentPkts) {
#               found = 0
# #printf("sentPkts[%s]: %s\n",i,sentPkts[i])
#               for (j in recvdPkts) {
#                       if (sentPkts[i] == recvdPkts[j]) {
#                               found = 1
#                               break
#                       }
#               }
#               if (found == 0) {
#                       lostPkts = lostPkts + 1
# #printf("lost packet: %s\n",sentPkts[i])
# }
#       }

        # computed failed packet transmissions
#       failed = 0
#       for (i in sendTime) {
#               if (sendTime[i] != 0 && (!(i in recvTime) || recvTime[i] == 0))
#                       failed = failed + 1
#       }
#  printf("failed: %s\n",lostPkts)

        # Compute average delay
        delay = avg_delay = recvdNum = 0
        for (i in recvTime) {
                if (sendTime[i] == 0) {
                        printf("\nError in delay.awk: receiving a packet that wasn't sent %g\n",i)
                }
                delay += recvTime[i] - sendTime[i]
                recvdNum ++
        }
#printf("revdNum: %s\n",recvdNum)
        if (recvdNum != 0) {
                avg_delay = delay / recvdNum
        } else {
                avg_delay = 0
        }

        # Compute average jitters
        jitter1 = jitter2 = jitter3 = jitter4 = jitter5 = 0
        prev_time = delay = prev_delay = processed = deviation = 0
        prev_delay = -1
        for (i=0; processed<recvdNum; i++) {
                if(recvTime[i] != 0) {
                        if(prev_time != 0) {
                                delay = recvTime[i] - prev_time
                                e2eDelay = recvTime[i] - sendTime[i]
                                if(delay < 0) delay = 0
                                if(prev_delay != -1) {
                                        jitter1 += abs(e2eDelay - prev_e2eDelay)
                                        jitter2 += abs(delay-prev_delay)
                                        jitter3 += (abs(e2eDelay-prev_e2eDelay) - jitter3) / 16
                                        jitter4 += (abs(delay-prev_delay) - jitter4) / 16
                                 }
                                 deviation += (e2eDelay-avg_delay)*(e2eDelay-avg_delay)
                                 prev_delay = delay
                                 prev_e2eDelay = e2eDelay
                        }
                        prev_time = recvTime[i]
                        processed++
                }
        }
        if (recvdNum != 0) {
                jitter1 = jitter1*1000/recvdNum
                jitter2 = jitter2*1000/recvdNum
        }
        if (recvdNum > 1) {
                jitter5 = sqrt(deviation/(recvdNum-1))
        }

        # Output
        if (recvdNum == 0) {
                printf("####################################################################\n" \
                       "#  Warning: no packets were received, simulation may be too short  #\n" \
                       "####################################################################\n\n")
        }
        printf("\n")
        printf(" %15s:  %g\n", "flowID", flow)
        printf(" %15s:  %s\n", "flowType", this_flow)
        printf(" %15s:  %d\n", "srcNode", src)
        printf(" %15s:  %d\n", "destNode", dst)
        printf(" %15s:  %g\n", "startTime", startTime)
        printf(" %15s:  %g\n", "stopTime", stopTime)
        printf(" %15s:  %g\n", "receivedPkts", recvdNum)
        printf(" %15s:  %g\n", "failedPkts", failed)
#       printf(" %15s:  %g\n", "delivery%", (recvdNum/(recvdNum+failed)))
        printf(" %15s:  %g\n", "delivery%", (recvs/sends))
        printf(" %15s:  %g\n", "avgTput[kbps]", (recvdSize/(stopTime-startTime))*(8/1000))
        printf(" %15s:  %g\n", "avgDelay[ms]", avg_delay*1000)
        printf(" %15s:  %g\n", "avgJitter1[ms]", jitter1)
        printf(" %15s:  %g\n", "avgJitter2[ms]", jitter2)
        printf(" %15s:  %g\n", "avgJitter3[ms]", jitter3*1000)
        printf(" %15s:  %g\n", "avgJitter4[ms]", jitter4*1000)
        printf(" %15s:  %g\n", "avgJitter5[ms]", jitter5*1000)

#       %9s %4s %4s %6s %5s %13s %14s %13s %15s %15s %15s %15s %15s\n\n",       \
#              "flow","flowType","src","dst","start","stop","receivedPkts",             \
#              "avgTput[kbps]","avgDelay[ms]","avgJitter1[ms]","avgJitter2[ms]",        \
#              "avgJitter3[ms]","avgJitter4[ms]","avgJitter5[ms]")
#       printf("  %6g %9s %4d %4d %6d %5d %13g %14s %13s %15s %15s %15s %15s\n\n",      \
#              flow,this_flow,src,dst,startTime, stopTime, recvdNum,                    \
#              (recvdSize/(stopTime-startTime))*(8/1000),avg_delay*1000,                \
#              jitter1,jitter2,jitter3*1000,jitter4*1000,jitter5*1000)
}

function abs(value) {
        if (value < 0) value = 0-value
        return value
}
