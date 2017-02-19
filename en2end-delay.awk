#
#      http://www.linuxquestions.org/questions/programming-9/awk-result-for-wireless-tcp-4175462686/#10
#

BEGIN {
highest_packet_id = 0;
}
{
action = $1;
time = $2;
#from = $3;
#to = $4;
type = $7; #aodv relationships,if 5 no infomation
pktsize = $8;
#src = $9;
#dst = $10;
#seq_no = $11;
packet_id = $6;

if ( type != "AODV" ) {

if ( packet_id > highest_packet_id )
highest_packet_id = packet_id;
if ( start_time[packet_id] == 0 )
start_time[packet_id] = time;

if ( type == "tcp" && action != "d" && $4 == "AGT") {
if ( action == "r" ) {
end_time[packet_id] = time;
}
} else {

end_time[packet_id] = -1;
}
}
}
END {

for ( packet_id = 0; packet_id <= highest_packet_id; packet_id++ ) {
start = start_time[packet_id];
end = end_time[packet_id];
packet_duration = end - start;

if ( start < end ) printf("%f %f\n", start, packet_duration);
}
} 
