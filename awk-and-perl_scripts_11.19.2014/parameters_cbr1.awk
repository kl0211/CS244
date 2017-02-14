#    http://www.linuxquestions.org/questions/linux-software-2/gpsr-patch-for-ns2-35-ubantu12-04-a-4175462077/#9
#  ============================= parameters.awk ========================
  BEGIN {
 sends=0;
 recvs=0;
 routing_packets=0.0;
 droppedBytes=0;
 droppedPackets=0;
 highest_packet_id =0;
 sum=0;
 recvnum=0;
##########################################################################################
 cbrpktno = 0; cbrbyte = 0;
##########################################################################################
   }
  {
 time = $3;
 packet_id = $41;
   #============= CALCULATE PACKET DELIVERY  FRACTION=================
 if (( $1 == "s") &&  ( $35 == "cbr" ) && ( $19=="AGT" ))   {  sends++; }
#####################################################################################
 if (( $1 == "s") &&  ( $35 == "cbr" ) && ( $19=="MAC" ))   {  cbrpktno ++; }
#####################################################################################
 if (( $1 == "r") &&  ( $35 == "cbr" ) && ( $19=="AGT" ))   {  recvs++; }
   #============= CALCULATE DELAY     ================================
 if ( start_time[packet_id] == 0 )  start_time[packet_id] = time;
 if (( $1 == "r") &&  ( $35 == "cbr" ) && ( $19=="AGT" )) {  end_time[packet_id] = time;  }
 else {  end_time[packet_id] = -1;  }
   #============= TOTAL AODV OVERHEAD  ================================
 if (($1 == "s" || $1 == "f") && $19 == "RTR" && $35 =="AODV") routing_packets++;
   #============= DROPPED DSR PACKETS ================================
 if (( $1 == "d" ) && ( $35 == "cbr" )  && ( $3 > 0 ))
 {
  droppedBytes=droppedBytes+$37;
  droppedPackets=droppedPackets+1;
 }
    #find the number of packets in the simulation
        if (packet_id > highest_packet_id)
  highest_packet_id = packet_id;
}
  END {
  for ( i in end_time )
 {
 start = start_time[i];
 end = end_time[i];
 packet_duration = end - start;
 if ( packet_duration > 0 )  { sum += packet_duration; recvnum++; }
 }
     delay=sum/recvnum*1000;
   RO = routing_packets/sends;     #routing overhead
   NRL = routing_packets/recvs;     #normalized routing load = routing load but it differ from routing overhead
   PDF = (recvs/sends)*100;         #packet delivery ratio[fraction]
##############################################################################
   APL = (cbrpktno/sends);      #average path length
##############################################################################
   printf("send = %.2f\n",sends);
   printf("MACpacketSend = %.2f\n",cbrpktno);
   printf("recv = %.2f\n",recvs);
   printf("routingpkts = %.2f\n",routing_packets++);
   printf("PDF = %.2f\n",PDF);
   printf("NRL = %.2f\n",NRL);
   printf("RoutingOverheads = %.2f\n",RO);
######################################################################################
   printf("AverageHopCounts = %.2f\n",APL);
######################################################################################
   printf("AverageDelaymsec = %.2f\n",delay);
   printf("DroppedDataPackets = %d\n",droppedPackets);
   printf("DroppedDataBytes = %d\n",droppedBytes);
   printf("PacketLoss = %.2f\n",(droppedPackets/(highest_packet_id+1))*100);
}
