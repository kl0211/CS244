#! /bin/tcsh -f

# Here is a tunneled shell command called jitter.sh combined with awk, 
# which calculates CBR traffic jitter at receiver node (n3) using data in "out.tr", 
# and stores the resulting data in "jitter.txt".
# This shell command selects the "CBR packet receive" event at n3, selects time (column 1) and
# sequence number (column 10), and calculates the difference from last packet receive time divided
# by difference in sequence number (for loss packets) for each sequence number


cat out.tr | grep " 2 3 cbr " | grep ^r | column 1 10 | awk '{dif = $2 - old2; if(dif==0) dif = 1; if(dif > 0) {printf("%d\t%f\n", $2, ($1 - old1) / dif); old1 = $1; old2 = $2}}' > jitter.txt

