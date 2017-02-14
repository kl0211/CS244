#    http://naveenshanmugam.blogspot.dk/2014/01/packet-delivery-ratio-calculation-in.html

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


$0 ~/^D.* cbr/ {

        dropLine ++ ;

}

END {

        printf "PacketDelivery Ratio:%.4f \n",(recvLine/sendLine);
} 
