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
    printf("") > "final_drops_868.txt";
    count1 = 0;
    count2 = 0;
}

{
    if ($0 == "")
	{
	    printf ("%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n", 
		    average(APS),
		    average(LQI),
		    average(END_),
		    average(COL),
		    average(DUP),
		    average(ERR),
		    average(RET),
		    average(STA),
		    average(BSY), 
		    average(NRTE),
		    average(LOOP),
		    average(TTL),
		    average(TOUT),
		    average(CBK),
		    average(IFQ),
		    average(ARP),
		    average(OUT),
		    average(IFQ1),
		    average(others)) >> "final_drops_868.txt";

	    count2 = count1;
	}
    else
	{
	    APS[count1] = $1
	    LQI[count1] = $2
	    END_[count1] = $3
	    COL[count1] = $4
	    DUP[count1] = $5
	    ERR[count1] = $6
	    RET[count1] = $7
	    STA[count1] = $8
	    BSY[count1] = $9 
	    NRTE[count1] = $10
	    LOOP[count1] = $11 
	    TTL[count1] = $12
	    TOUT[count1] = $13
	    CBK[count1] = $14
	    IFQ[count1] = $15
	    ARP[count1] = $16
	    OUT[count1] = $17
	    IFQ1[count1] = $18
	    others[count1] = $19
	    
	    count1++;
	}
}
