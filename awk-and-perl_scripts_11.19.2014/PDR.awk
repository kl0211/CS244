# Packet delivery Ratio   
# http://harrismare.net/2011/07/14/packet-delivery-ratio-packet-lost-end-to-end-delay/



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
