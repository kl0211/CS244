# http://mohit.ueuo.com/AWK_Scripts/totalpacketssent.awk


BEGIN {

count = 0;

}

{

action = $1;

time = $2;

node_id = $3;

layer = $4;

flags = $5;

seqno = $6;

type = $7;

size = $8;

a = $9;

b = $10;

c = $11;

d = $12;

energy = $14;

for(seqno = 0; seqno < 68; seqno++) {

if((node_id = "_0_" && action == "s" && layer == "AGT" && type == "cbr" && size >= 1000) || (node_id = "_1_" && action == "s" && layer == "AGT" && type == "cbr" && size >= 1000) || (node_id = "_2_" && layer == "AGT" && action == "s" && type == "cbr" && size >= 1000) || (node_id = "_3_" && action == "s" && layer == "AGT" && type == "cbr" && size >= 1000) || (node_id = "_5_" && action == "s" && layer == "AGT" && type == "cbr" && size >= 1000) || (node_id = "_6_" && action == "s" && layer == "AGT" && type == "cbr" && size >= 1000)) {

count++;

}

}

}

END {
printf("%d\n",count);
}