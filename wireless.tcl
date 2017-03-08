# This script is created by NSG2 beta1
# <http://wushoupong.googlepages.com/nsg>

#===================================
#     Simulation parameters setup
#===================================
set val(chan)   Channel/WirelessChannel    ;# channel type
set val(prop)   Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)  Phy/WirelessPhy            ;# network interface type
set val(mac)    Mac/802_11                 ;# MAC type
set val(ifq)    Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)     LL                         ;# link layer type
set val(ant)    Antenna/OmniAntenna        ;# antenna model
set val(ifqlen) 50                         ;# max packet in ifq
set val(nn)     5                          ;# number of mobilenodes
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
set f3 [open graph3.tr w]
set f4 [open graph4.tr w]

#===================================
#     Mobile node parameter setup
#===================================
# Set Data Rate. Default at 1Mb/sec
$val(mac) set dataRate_ 54.0e6

#$val(netif) set RXThresh_ 3.65262e-10
$val(netif) set Pt_ 1.000

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
#Create 5 nodes

#Base station
set n0 [$ns node]
$n0 set X_ 300
$n0 set Y_ 600
$n0 set Z_ 0.0
$ns initial_node_pos $n0 20

set n1 [$ns node]
$n1 set X_ 325
$n1 set Y_ 600
$n1 set Z_ 0.0
$ns initial_node_pos $n1 20
set n2 [$ns node]
$n2 set X_ 250
$n2 set Y_ 600
$n2 set Z_ 0.0
$ns initial_node_pos $n2 20
set n3 [$ns node]
$n3 set X_ 300
$n3 set Y_ 525
$n3 set Z_ 0.0
$ns initial_node_pos $n3 20
set n4 [$ns node]
$n4 set X_ 300
$n4 set Y_ 943
$n4 set Z_ 0.0
$ns initial_node_pos $n4 20

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
$ns attach-agent $n1 $tcp1
$ns attach-agent $n2 $tcp2
$ns attach-agent $n3 $tcp3
$ns attach-agent $n4 $tcp4

for {set i 1} {$i <= $val(nn)} {incr i} {
    set sink$i [new Agent/TCPSink]
}
$ns attach-agent $n0 $sink1
$ns attach-agent $n0 $sink2
$ns attach-agent $n0 $sink3
$ns attach-agent $n0 $sink4

$ns connect $tcp1 $sink1
$ns connect $tcp2 $sink2
$ns connect $tcp3 $sink3
$ns connect $tcp4 $sink4

#===================================
#        Applications Definition        
#===================================
#Setup a FTP Application over TCP connection
#with random packet sizes at each second
for {set i 1} {$i <= $val(nn)} {incr i} {
    set ftp$i [new Application/FTP]
}

$ftp1 attach-agent $tcp1
$ftp2 attach-agent $tcp2
$ftp3 attach-agent $tcp3
$ftp4 attach-agent $tcp4

$ns at 1.0 "$ftp1 start"
for {set i 2}  {$i < 145} {incr i} {
    set size [getRandomPacketSize]
    puts "at time $i.0 sec, packet size changed to: $size"
    $ns at $i.0 "$tcp1 set packetSize_ $size"
}
$ns at 145.0 "$ftp1 stop"

$ns at 1.0 "$ftp3 start"
for {set i 2}  {$i < 145} {incr i} {
    set size [getRandomPacketSize]
    puts "at time $i.0 sec, packet size changed to: $size"
    $ns at $i.0 "$tcp3 set packetSize_ $size"
}
$ns at 145.0 "$ftp3 stop"

#Setup a FTP Application over TCP connection
$ns at 1.0 "$ftp2 start"
$ns at 145.0 "$ftp2 stop"
$ns at 1.0 "$ftp4 start"
$ns at 145.0 "$ftp4 stop"

#===================================
#        Termination        
#===================================
proc record {} {
    global sink1 sink2 sink3 sink4 f1 f2 f3 f4
    set ns [Simulator instance]
    set time 0.5
    set bw1 [$sink1 set bytes_]
    set bw2 [$sink2 set bytes_]
    set bw3 [$sink3 set bytes_]
    set bw4 [$sink4 set bytes_]
    set now [$ns now]
    # Y-Axis to show Kbps
    puts $f1 "$now [expr $bw1/$time*8/1000]"
    puts $f2 "$now [expr $bw2/$time*8/1000]"
    puts $f3 "$now [expr $bw3/$time*8/1000]"
    puts $f4 "$now [expr $bw4/$time*8/1000]"
    $sink1 set bytes_ 0
    $sink2 set bytes_ 0
    $sink3 set bytes_ 0
    $sink4 set bytes_ 0
    $ns at [expr $now+$time] "record"
}

#Define a 'finish' procedure
proc finish {} {
    global ns tracefile namfile f1 f2 f3 f4
    $ns flush-trace
    close $tracefile
    close $namfile
    close $f1
    close $f2
    close $f3
    close $f4
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
