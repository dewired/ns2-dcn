set ns [new Simulator]  

set nf [open expt1.nam w]
$ns namtrace-all $nf     
set tf [open expt1.tr w]
$ns trace-all $nf

set n0 [$ns node]      
set n1 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail  

proc finish {} {
  global ns nf tf
  $ns flush-trace
  close $nf
  close $tf
  exec nam expt1.nam &
  exit 0
}

$ns at 5.0 "finish"
$ns run
}



