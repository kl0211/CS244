# Run as: awk -f thpt.awk out.tr
BEGIN {
	receivedBytes = 0;
	flowId = -1;
	simtime = 4.0;
}

{
	event = $1;
	pktType = $5;
	pktSize = $6;

	sourceProcess = $9;
	destinationProcess = $10;

	flowId = -1;

	if(sourceProcess == "0.0" && destinationProcess == "1.0") flowId = 1;

	if (event == "r" && pktType == "cbr" && flowId == 1) {
		receivedBytes += pktSize;
	}
}
END {
	thpt = receivedBytes*8/simtime;

	printf("Throughput of flow %d = %d bps\n", flowId, thpt);
}
