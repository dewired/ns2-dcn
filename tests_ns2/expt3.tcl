set ns [new Simulator]
$ns color 1 Blue
$ns color 2 Red

set nf [open expt3.nam w]
set tf [open expt3.tr w]
$ns namtrace-all $nf
$ns trace-all $tf

proc finish {} {
  global ns nf tf
  $ns flush-trace
  close $nf
  close $tf
  exec nam expt3.nam &
  exec awk -f drop.awk expt3.tr &
  exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]


$ns duplex-link $n0 $n2 1Mb 10ms RED
$ns duplex-link $n1 $n2 1Mb 10ms RED
$ns duplex-link $n2 $n3 1Mb 10ms RED

# You can use different queuing mechanisms such as Droptail, or SFQ or RED



set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 500
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1


set null0 [new Agent/Null]
$ns attach-agent $n3 $null0
$udp0 set class_ 1
$udp1 set class_ 2
$ns connect $udp0 $null0
$ns connect $udp1 $null0

$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"
$ns at 1.0 "$cbr1 start"
$ns at 4.0 "$cbr1 stop" 
$ns at 5.0 "finish"
$ns run

