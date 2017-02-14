#      http://mohittahiliani.blogspot.dk/2011/08/awk-scripts-for-normalized-routing.html
####################################################################
#         AWK Script to calculate Normalized Routing Load          #
#              Works with AODV, DSDV, DSR and OLSR		   #
####################################################################

BEGIN{
recvd = 0;#################### to calculate total number of data packets received
rt_pkts = 0;################## to calculate total number of routing packets received
}

{
##### Check if it is a data packet
if (( $1 == "r") && ( $35 == "cbr" || $35 =="tcp" ) && ( $19=="AGT" )) recvd++;

##### Check if it is a routing packet
if (($1 == "s" || $1 == "f") && $19 == "RTR" && ($35 =="AODV" || $35 =="message" || $35 =="DSR" || $35 =="OLSR")) rt_pkts++;
}

END{
printf("##################################################################################\n");
printf("\n");
printf("                       Normalized Routing Load = %.3f\n", rt_pkts/recvd);
printf("\n");
printf("##################################################################################\n");
}
