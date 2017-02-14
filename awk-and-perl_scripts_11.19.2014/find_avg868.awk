# Vaddina Prakash Rao
# Chair of Telecommunications
# TU Dresden.

# COMMAND TO EXECUTE THIS SCRIPT FILE WITH A PARSING TRACE FILE: awk -f <awk-script-filename.awk> <filename.tr>

function average (array) {
    #printf ("%d - %d\n", count1, count2);
    sum = 0;
    items = 0;
    for (i=count2; i<count1; i++) {
        sum += array[i];
        items++;
    }
    if (sum == 0 || items == 0)
        return 0;
    else
        return sum/items;
}

BEGIN {
    printf("") > "final_graphs_868.txt";
    count1 = 0;
    count2 = 0;
}

{
    if ($0 == "")
	{
	    printf ("%f %f %f %f %d %d %d %f %f %f %f %f\n", 
		    average(throughput),
		    average(max_delay),
		    average(min_delay),
		    average(avg_delay),
		    average(pkts),
		    average(pktr),
		    average(pktd),
		    average(del_ratio),
		    average(start_ener),
		    average(ener_used),
		    average(percent_used),
		    average(pkt_discrepancy_ratio)) >> "final_graphs_868.txt";

	    count2 = count1;
	}
    else
	{
	    throughput[count1] = $1;
	    max_delay[count1] = $2;
	    min_delay[count1] = $3;
	    avg_delay[count1] = $4;
	    pkts[count1] = $5;
	    pktr[count1] = $6;
	    pktd[count1] = $7;
	    del_ratio[count1] = $8;
	    start_ener[count1] = $9;
	    ener_used[count1] = $10;
	    percent_used[count1] = $11;
	    pkt_discrepancy_ratio[count1] = $12;
	    count1++;
	}
}
