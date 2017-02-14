BEGIN {

seqno = -1;
droppedPackets = 0;
count = 0;
num = 0;
flag = -1;
}
{
if ($1 == "+" && $5 =="tcp" && seqno < $12){
seqno = $12;
temp = seqno +1 ;
flag = 1;
} else if (seqno == $12) {
flag = -1;
}
if (seqno >-1 ){

if ($1 == "+" && $5 =="tcp" && flag == 1){
start_time[seqno] = $2;
packetID[seqno] = seqno;
time[seqno] = $2;

} else if(($7 == "tcp") && ($1 == "r") && $6 == seqno) {
end_time[seqno] = $2;

}
} ###if seqno > -1

}


END {

for(i=0; i<=seqno; i++) {
if(end_time[i] > 0) {

delay[i] = end_time[i] - start_time[i];
print time[i]" " delay[i] ;
count++;
} else
{
delay[i] = -1;
}
}

} 
