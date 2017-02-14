BEGIN {
nSentPackets = 0 ;
nReceivedPackets = 0 ;
nAGTReceivedPackets = 0;
nDropPackets = 0;
rTotalDelay = 0.0 ; #total delay
Max=0;
nrtr = 0; # number of the routing control packets
traffic=0;
}

#######################################################################
{
strEvent = $1 ; rTime = $2 ; strNode= $3 ;
strAgt = $8 ; idPacket = $11 ;
strType = $12 ; packetSize= $13 ;

if (idPacket>Max)
Max=idPacket;
#looping over all the packets in the trace file to check whether it is a data packet or a control packet

if ( strAgt == "AGT" && strType == "cbr" )
{
if ( strEvent == "s" )
{
nSentPackets += 1 ;
rSentTime[ idPacket ] = rTime ; # this takes care for the sent agent packets
}
else if (strEvent == "r")
{
nAGTReceivedPackets += 1 ;
rReceivedTime[ idPacket ] = rTime ;
}
}

if ( strAgt == "RTR" && strType == "cbr" )
{
if ( strEvent == "r" )
{
nReceivedPackets += 1 ;# this takes care for the received agent packets

}
else if (strEvent == "D")
{
nDropPackets += 1; # this takes care of dropped packets

}
}


# AODV control packets have a string type of AODV
# need to calculate the traffic in terms of the packet size

if ( strgAgt == "RTR" && strType == "AODV")

{ if (strEvent == "s")

{ nrtr++;
traffic = traffic+packetSize;
}
}



}

#######################################################################

END {
# need to calculate now the total delay (end to end delay)
# id of the packet starts from 0 since the array starting index is 0
for (idPacket=0 ;idPacket<=Max; idPacket++) {
if(rReceivedTime[idPacket]>0 && rSentTime[idPacket]>0) {
rTotalDelay+=rReceivedTime[idPacket]-rSentTime[idPacket];
}
}

#we are using the 802.11p of frequency 5.9 GHz
#parameters of 802.11p are set for 10MHz bandwidth
printf("Total Delay ms:%f \n", 1000*rTotalDelay);
printf("Total Sent AGT CBR Packets :%f \n", nSentPackets);
printf("Total Drop RTR Packets :%f \n", nDropPackets);
printf("Number of RTR received packets:%f\n", nReceivedPackets);
printf("Number of Agent CBR received packets:%f\n", nAGTReceivedPackets);
printf("Average Delay ms:%f \n", 1000*rTotalDelay/nAGTReceivedPackets);
printf("Packet Delivery ratio PDR %f\n",(nAGTReceivedPackets)/nSentPackets);
printf(" The throughput in bits per second is %f\n",300*8*nAGTReceivedPackets/100);
printf(" The spectral Efficiency in b/s/Hz is %f\n",300*8*nAGTReceivedPackets/(100*10000));
printf("\n");
