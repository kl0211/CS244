# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/FreeSpace      ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     3                          ;# number of mobilenodes
set val(rp)     DSDV                       ;# routing protocol
set val(x)      1000                       ;# X dimension of topography
set val(y)      1000                       ;# Y dimension of topography
set val(stop)   150.0                      ;# time of simulation end

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
$ns trace-all $tracefile

#Open the NAM trace file
set namfile [open out.nam w]
$ns namtrace-all $namfile
$ns namtrace-all-wireless $namfile $val(x) $val(y)
set chan [new $val(chan)];#Create wireless channel

#Record Data for Xgraph
set f0 [open graph0.tr w]
set f1 [open graph1.tr w]

#===================================
#     Mobile node parameter setup
#===================================
# Set Data Rate. Default at 1Mb/sec
$val(mac) set dataRate_ 54.0e6

#$val(netif) set RXThresh_ 3.65262e-10
$val(netif) set Pt_ 0.0005

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
                -movementTrace ON

#===================================
#        Nodes Definition        
#===================================
#Create 3 nodes
set n0 [$ns node]
$n0 set X_ 300
$n0 set Y_ 600
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20
set n1 [$ns node]
$n1 set X_ 250
$n1 set Y_ 600
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set n2 [$ns node]
$n2 set X_ 325
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
set tcp1 [new Agent/TCP]
$ns attach-agent $n1 $tcp1

set tcp2 [new Agent/TCP]
$ns attach-agent $n2 $tcp2

set sink1 [new Agent/TCPSink]
$ns attach-agent $n0 $sink1

set sink2 [new Agent/TCPSink]
$ns attach-agent $n0 $sink2

$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2

#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP connection
#with random packet sizes at each second
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns at 1.0 "$ftp1 start"
for {set i 2}  {$i < 145} {incr i} {
    set size [getRandomPacketSize]
    puts "at time $i.0 sec, packet size changed to: $size"
    $ns at $i.0 "$tcp1 set packetSize_ $size"
}
$ns at 145.0 "$ftp1 stop"

#Setup a FTP Application over TCP connection
set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2
$ns at 1.0 "$ftp2 start"
$ns at 145.0 "$ftp2 stop"


#===================================
#        Termination        
#===================================
proc record {} {
    global sink1 sink2 f0 f1
    set ns [Simulator instance]
    set time 0.25
    set bw0 [$sink1 set bytes_]
    set bw1 [$sink2 set bytes_]
    set now [$ns now]
    # Y-Axis to show Kbps
    puts $f0 "$now [expr $bw0/$time*8/1000]"
    puts $f1 "$now [expr $bw1/$time*8/1000]"
    $sink1 set bytes_ 0
    $sink2 set bytes_ 0
    $ns at [expr $now+$time] "record"
}

#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile f0
    $ns flush-trace
    close $tracefile
    close $namfile
    close $f0
    exit 0
}
for {set i 1} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "\$n$i reset"
}
$ns at 0.0 "record"
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "finish"
$ns at $val(stop) "puts \"done\" ; $ns halt"
$ns run
