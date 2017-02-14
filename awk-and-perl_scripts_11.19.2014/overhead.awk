BEGIN{
recvs = 0;
routing_packets = 0;
}

{
if (( $1 == "r") &&  ( $35 == "cbr" ) && ( $19=="AGT" ))  recvs++;
if (($1 == "s" || $1 == "r") && $19 == "RTR" && $35 =="AODV")    routing_packets++;    
}

END{
printf("\nrouting packets %d", routing_packets);
printf("\ndata = %d", recvs);
printf("\nNRL = %.3f\n", routing_packets/recvs);
}

