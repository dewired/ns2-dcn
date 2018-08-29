
# ======================================================================
# Define options
# ======================================================================
set val(chan)           "Channel/WirelessChannel"  ;# channel type
set val(prop)           "Propagation/TwoRayGround" ;# radio-propagation model
set val(netif)          "Phy/WirelessPhy"          ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            "Queue/DropTail/PriQueue"  ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            "Antenna/OmniAntenna"      ;# antenna model
set val(x)		500	                   ;# topology size
set val(y)		500                        ;# topology size
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             6                          ;# number of mobilenodes
set val(rp)             DSDV                       ;# routing protocol

# ======================================================================
# Main Program
# ======================================================================


#
# Initialize Global Variables
#
set ns_			[new Simulator]
$ns_ color 1 Blue
$ns_ color 2 Red

set tracefd     [open mobwless.tr w]
$ns_ trace-all $tracefd
$ns_ use-newtrace

set namtrace [open wless_asgn.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)



# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

#
# Create God
#
create-god $val(nn)

#
#  Create the specified number of mobilenodes [$val(nn)] and "attach" them
#  to the channel. 
#  Here five nodes are created : node(0), node(1), node(2), node(3), node(4), node(5)

# configure node

        $ns_ node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace ON 			
			 
	for {set i 0} {$i < $val(nn) } {incr i} {
		set node_($i) [$ns_ node]	
		$node_($i) random-motion 0		;# disable random motion
	}

#
# initial (X,Y, for now Z=0) co-ordinates for mobile nodes
#
$node_(1) set X_ 17.0
$node_(1) set Y_ 25.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 47.0
$node_(2) set Y_ 1.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 435.0
$node_(3) set Y_ 234.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 67.0
$node_(4) set Y_ 123.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 332.0
$node_(5) set Y_ 313.0
$node_(5) set Z_ 0.0

$node_(0) set X_ 233.0
$node_(0) set Y_ 167.0
$node_(0) set Z_ 0.0

for {set i 0} {$i < $val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 20
}

#
# some simple node movements
#
$ns_ at 0.5 "$node_(1) setdest 183.0 183.0 47.0"
$ns_ at 10.0 "$node_(2) setdest 183.0 183.0 14.0"
$ns_ at 20.0 "$node_(3) setdest 183.0 183.0 23.0"
$ns_ at 30.0 "$node_(4) setdest 183.0 183.0 11.0"
$ns_ at 40.0 "$node_(5) setdest 183.0 183.0 34.0"
$ns_ at 50.0 "$node_(0) setdest 183.0 183.0 29.0"



# Setup traffic flow between nodes
# TCP connections between node_(0) and node_(3)

set tcp0 [new Agent/TCP]
$tcp0 set class_ 1
set sink0 [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp0
$ns_ attach-agent $node_(3) $sink0
$ns_ connect $tcp0 $sink0
set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ns_ at 10.0 "$ftp0 start" 
$ns_ at 22.0 "$ftp0 stop" 

# TCP connections between node_(2) and node_(5)

set tcp1 [new Agent/TCP]
$tcp1 set class_ 2
set sink1 [new Agent/TCPSink]
$ns_ attach-agent $node_(2) $tcp1
$ns_ attach-agent $node_(5) $sink1
$ns_ connect $tcp1 $sink1
set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ns_ at 30.0 "$ftp1 start"
$ns_ at 45.0 "$ftp1 stop" 

#
# Tell nodes when the simulation ends
#
for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at 60.0 "$node_($i) reset";
}
$ns_ at 60.0 "stop"
$ns_ at 60.01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
   # close $namtrace
    exec nam wless_asgn.nam &
    exec awk -f results_assignment.awk mobwless.tr &
    exit 0
}

puts "Starting Simulation..."
$ns_ run

