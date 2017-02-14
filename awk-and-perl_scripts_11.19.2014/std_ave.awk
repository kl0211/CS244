BEGIN {
	total=0.0
	flowNum=0.0
 }

   val[flowNum]=$2
   flowNum++
   total=total+$2

 END {
	av=total/flowNum
	for (i in val) {
	   d=val[i]-av
	   s2=s2+d*d
    	}
	print "total session number: " flowNum 
	print "average delay: " av "sec"
        print "standard deviation: " sqrt(s2/nl) "sec"
	
     }
