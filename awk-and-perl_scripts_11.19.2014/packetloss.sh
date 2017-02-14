#!/bin/bash

#global variables
NB_RUN=10



run_packet_loss()
{

        RECV=`grep "cbr" out.res | grep ^r | grep "MAC" | grep "Hs 6" | awk 'BEGIN{i=0}{i++}END{print i}'`
	echo $RECV
        RECV2=`grep "cbr" out.res | grep ^r | grep "MAC" | grep "Hs 4" | awk 'BEGIN{i=0}{i++}END{print i}'`
	echo $RECV2
        
          RECV3=`echo $RECV + $RECV2 | bc`
        
        SEND=`grep "0 1 cbr" out.res | grep ^+ | awk 'BEGIN{i=0}{i++}END{print i}'`
	echo $SEND
        LOST=`echo $LOST $RECV3 $SEND | awk '{print $1+$3-$2}'`
	TMP=`echo $RECV3 $SEND | awk '{print $2-$1}'`
        	echo " lost=" $TMP

}


run_packet_loss

