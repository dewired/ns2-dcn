set ns [new Simulator]
set nf [open expt2.nam w]
$ns namtrace-all $nf
set tf [open expt2.tr w]
$ns trace-all $tf

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 1Mb 10ms DropTail
$ns duplex-link $n4 $n1 1Mb 10ms DropTail
$ns duplex-link $n1 $n2 1Mb 10ms DropTail
$ns duplex-link $n2 $n5 1Mb 10ms DropTail
$ns duplex-link $n2 $n3 1Mb 10ms DropTail


set tcp_1 [new Agent/TCP]
$ns attach-agent $n0 $tcp_1

set tcp_2 [new Agent/TCP]
$ns attach-agent $n4 $tcp_2

set sink_1 [new Agent/TCPSink]
$ns attach-agent $n3 $sink_1
$ns connect $tcp_1 $sink_1

set sink_2 [new Agent/TCPSink]
$ns attach-agent $n5 $sink_2
$ns connect $tcp_2 $sink_2

set ftp_1 [new Application/FTP]
$ftp_1 attach-agent $tcp_1

set ftp_2 [new Application/FTP]
$ftp_2 attach-agent $tcp_2


proc finish {} {
  global ns nf tf
  $ns flush-trace
  close $nf
  close $tf
  exec nam expt2.nam &
  # exec awk -f receive.awk expt2.tr &
  exit 0
}

$ns at 0.5 "$ftp_1 start"
$ns at 2.5 "$ftp_1 stop"
$ns at 3.0 "$ftp_2 start"
$ns at 4.5 "$ftp_2 stop" 
$ns at 5.0 "finish"
$ns run

