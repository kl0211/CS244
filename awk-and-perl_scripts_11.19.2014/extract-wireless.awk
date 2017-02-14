{
	if(($1 == type) && 
	   ($9 == node) && 
	   ($19 == level) && 
	   (index($0, "-It "traffic) > 0)){
		for(i=1; (i <= NF) && ($i != "-"field); i++) ;
		print $3 " "$(i+1);
		#print $0
	}
}

