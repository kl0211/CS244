# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model.
# TwoRayGround considers ground reflection in the transmission.
# More accurate than FreeSpace model, and is used commonly in other
# scripts.

set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# Droptail/PriQueue queue
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 9                         ;# max packet in ifq (Buffer Size)
set val(nn)     3                          ;# number of mobilenodes
set val(rp)     DSDV                       ;# routing protocol
# Destination-Sequenced Distance Vector

set val(x)      1000                       ;# X dimension of topography
set val(y)      1000                       ;# Y dimension of topography
set val(stop)   150.0                      ;# time of simulation end

# MAC specifications for 802.11/b (hopefully)
$val(mac) set SlotTime_          2.0e-6    ;# 2us
$val(mac) set SIFS_              1.0e-6    ;# 1us
$val(mac) set DIFS_              1.0e-6    ;# 1us
$val(mac) set PreambleLength_    144       ;# 144 bit
$val(mac) set PLCPHeaderLength_  48        ;# 48 bits
$val(mac) set PLCPDataRate_      1.0e6     ;# 1Mbps
$val(mac) set dataRate_          11.0e6    ;# 11Mbps
$val(mac) set basicRate_         11.0e6    ;# 11Mbps
$val(mac) set RTSThreshold_      3000      ;# Use RTS/CTS for packets larger 3000 bytes

#===================================
#        Initialization        
#===================================
#Create a ns simulator
set ns [new Simulator]

#Setup topography object
set topo       [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

#Open the NS trace file
set tracefile [open out.tr w]
$ns use-newtrace
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#Record Data for Xgraph
set f1 [open graph1.tr w]
set f2 [open graph2.tr w]

#===================================
#     Mobile node parameter setup
#===================================
# Set Transmission Power. Standard for 802.11g is 100 mW

$val(netif) set Pt_ 0.100 ;# Pt_ value in watts

$ns node-config -adhocRouting  $val(rp) \
                -llType        $val(ll) \
                -macType       $val(mac) \
                -ifqType       $val(ifq) \
                -ifqLen        $val(ifqlen) \
                -antType       $val(ant) \
                -propType      $val(prop) \
                -phyType       $val(netif) \
                -channel       $chan \
                -topoInstance  $topo \
                -agentTrace    ON \
                -routerTrace   ON \
                -macTrace      ON \
                -movementTrace ON \

#===================================
#        Nodes Definition        
#===================================
#Create 2 nodes

set n0 [$ns node] ;#Base station 1
$n0 set X_ 300
$n0 set Y_ 600
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20

set n1 [$ns node] ;#10 meters west of n0
$n1 set X_ 290
$n1 set Y_ 600
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20

set n2 [$ns node] ;#10 meters east of n0
$n2 set X_ 310
$n2 set Y_ 600
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20

#===================================
#        Agents Definition        
#===================================
proc getRandomPacketSize {} {
    #Between 500 and 5000
    return [expr {500 + int(rand() * 4500)}]
}

#Setup TCP connections
for {set i 1} {$i <= $val(nn)} {incr i} {
    set tcp$i [new Agent/TCP]
}

#Couldn't figure out how to put these in the for loop. $n$i doesn't seem
#to work.
#Attach TCP connections to nodes
$ns attach-agent $n1 $tcp1
$ns attach-agent $n2 $tcp2

#Setup TCP sinks
for {set i 1} {$i <= $val(nn)} {incr i} {
    set sink$i [new Agent/TCPSink]
}
#Attach TCP sinks to nodes
$ns attach-agent $n0 $sink1
$ns attach-agent $n0 $sink2

#Connect TCP connections with sinks
$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2

#===================================
#        Applications Definition        
#===================================
#Setup an FTP Application over TCP connection
for {set i 1} {$i <= $val(nn)} {incr i} {
    set ftp$i [new Application/FTP]
}

#Attach FTP applications to TCP connections
$ftp1 attach-agent $tcp1
$ftp2 attach-agent $tcp2

#Set TCP connection packet sizes
$tcp1 set packetSize_ 1500 ;# Start with 1.5KB packetsize
$tcp2 set packetSize_ 1500

#Start/Stop nodes times
$ns at 1.0 "$ftp1 start"
# Uncomment for loop below to make ftp send random packet sizes
# for {set i 2}  {$i < 145} {incr i} {
#     set size [getRandomPacketSize]
#     #puts "at time $i.0 sec, packet size changed to: $size"
#     $ns at $i.0 "$tcp1 set packetSize_ $size"
# }
$ns at 145.0 "$ftp1 stop"

$ns at 1.0 "$ftp2 start"
# Uncomment for loop below to make ftp send random packet sizes
# for {set i 2}  {$i < 145} {incr i} {
#     set size [getRandomPacketSize]
#     #puts "at time $i.0 sec, packet size changed to: $size"
#     $ns at $i.0 "$tcp2 set packetSize_ $size"
# }
$ns at 145.0 "$ftp2 stop"


#===================================
#        Termination        
#===================================
proc record {} {
    global sink1 sink2 f1 f2
    set ns [Simulator instance]
    set time 0.5
    set bw1 [$sink1 set bytes_]
    #set bw2 [$sink2 set bytes_]
    set now [$ns now]
    # Y-Axis to show Kbps
    puts $f1 "$now [expr $bw1/$time*8/1000]"
    #puts $f2 "$now [expr $bw2/$time*8/1000]"
    $sink1 set bytes_ 0
    #$sink2 set bytes_ 0
    $ns at [expr $now+$time] "record"
}

#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile f1 f2
    $ns flush-trace
    close $tracefile
    close $namfile
    close $f1
    close $f2
    exit 0
}
for {set i 1} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
#$ns at 0.0 "record"
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
