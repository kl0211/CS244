#      https://github.com/f2008700/NS2/blob/master/ns2/thruput.awk


# execute on terminal as: awk -f e2e.awk out.tr /and after that enter the source node
# The source node number should be the same as from which ftp/tcp is started


BEGIN {

printf "Enter source node: "
     getline node < "-"

fromNode=1; toNode=0;

src1 = node+0.4; dst1 = 0.4;

fromNode1=4;

lineCount1 = 0;totalBits1 = 0;

lineCount2 = 0;totalBits2 = 0;

packetsent = 0; packetsrecv=0;


}


/^r/&&$3==fromNode&&$4==toNode&&$9==src1&&$10==dst1 {

    totalBits1 += 8*$6;
    packetsent +=1;

if ( lineCount1==0 ) {

timeBegin1 = $2; lineCount1++;

} else {

timeEnd1 = $2;

};

};

/^r/&&$3==fromNode1&&$4==toNode&&$9==src2&&$10==dst1 {

    totalBits2 += 8*$6;

if ( lineCount2==0 ) {

timeBegin2 = $2; lineCount2++;

} else {

timeEnd2 = $2;

};

};

#packets recv = check for number of acks sent

/^r/&&$3==toNode&&$4==fromNode&&$9==dst1&&$10==src1 {

packetsrecv += 1;

};

/^r/&&$3==toNode&&$4==fromNode1&&$9==dst1&&$10==src1 {

packetsrecv += 1;

};

END{

duration1 = timeEnd1-timeBegin1;
duration2 = timeEnd2-timeBegin2;
if ( duration1 >= duration2 ) {

duration = duration1;

} else {

duration = duration2;

};

#printf "node-5 is " $5;

#print "Number of records is " NR;

print "Number of packets sent is " packetsent;

print "Number of packets recv is " packetsrecv;

print "Transmission: source " node "->Destination" dst1;

print " - Total transmitted bytes = "( totalBits1+totalBits2 )/8 " bytes";


print " - duration = " duration " s";

if ( duration==0 ) {

print " - Throughput = 0 ";

} else {

print " - Throughput = " ( totalBits1+totalBits2 )/duration/1.024e3 " kbps.";

print " ";

};

};