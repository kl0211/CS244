BEGIN{  print "Flow ID = " fid;  }
{
	if(($1 == "r") && ($8 == fid)){
	   if(s==0){
		   s=1;  
		   start=$2;
	   } 
	   bytes+=$6; 
	   time=$2;
  	 }
}
END{ 
	print "Throughput of flow " fid " = " bytes*8/(time-start) 
}
