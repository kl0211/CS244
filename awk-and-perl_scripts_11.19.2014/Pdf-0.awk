# http://mohittahiliani.blogspot.dk/2009/12/awk-script-for-ns2.html
#
# pdf.awk : AWK script for pdf (packet delivery fraction)

BEGIN {
        sendLine = 0;
        recvLine = 0;
        fowardLine = 0;
}
 
$0 ~/^s.* AGT/ {
        sendLine ++ ;
}
 
$0 ~/^r.* AGT/ {
        recvLine ++ ;
}
 
$0 ~/^f.* RTR/ {
        fowardLine ++ ;
}
 
END {
        printf "cbr s:%d r:%d, r/s Ratio:%.4f, f:%d \n", sendLine, recvLine, (recvLine/sendLine),fowardLine;
}
 