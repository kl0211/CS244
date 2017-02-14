# http://mohit.ueuo.com/AWK_Scripts.html
# 
# http://mohit.ueuo.com/AWK_Scripts/cwnd.awk
# Plotting a congestion window 

BEGIN {

}
{
if($6=="cwnd_") {
	printf("%f\t%f\n",$1,$7);
}
}
END {

}
