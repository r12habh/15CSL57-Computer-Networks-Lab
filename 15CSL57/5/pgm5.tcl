set ns [new Simulator]
set tf [open Lab5.tr w]
$ns trace-all $tf

set bwDL(gsm) 9600
set bwUL(gsm) 9600
set propDL(gsm) .500
set propUL(gsm) .500

set buf(gsm) 10

set c1 [$ns node]
set ms [$ns node]
set bs1 [$ns node]
set bs2 [$ns node]
set c2 [$ns node]
proc cell_topo {} {
global ns nodes
$ns duplex-link $c1 $bs1 3Mbps 10ms DropTail
$ns duplex-link $bs1 $ms 1 1 RED
$ns duplex-link $ms $bs2 1 1 RED
$ns duplex-link $bs2 $c2 3Mbps 50ms DropTail
}
switch gsm {
gsm -
gprs -
umts {cell_topo}
}
$ns bandwidth $bs1 $ms $bwDL(gsm) simplex
$ns bandwidth $ms $bs1 $bwUL(gsm) simplex
$ns bandwidth $bs2 $ms $bwDL(gsm) simplex
$ns bandwidth $ms $bs2 $bwUL(gsm) simplex
$ns delay $bs1 $ms $propDL(gsm) simplex
$ns delay $ms $bs1 $propDL(gsm) simplex
$ns delay $bs2 $ms $propDL(gsm) simplex
$ns delay $ms $bs2 $propDL(gsm) simplex
$ns queue-limit $bs1 $ms $buf(gsm)
$ns queue-limit $ms $bs1 $buf(gsm)
$ns queue-limit $bs2 $ms $buf(gsm)
$ns queue-limit $ms $bs2 $buf(gsm)
$ns insert-delayer $ms $bs1 [new Delayer]
$ns insert-delayer $bs1 $ms [new Delayer]
$ns insert-delayer $ms $bs2 [new Delayer]
$ns insert-delayer $bs2 $ms [new Delayer]
set tcp [new Agent/TCP]
$ns attach-agent $c1 $tcp
set sink [new Agent/TCPSink]
$ns attach-agent $c2 $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns connect $tcp $sink
proc End {} {
global ns tf
$ns flush-trace
close $tf
exec awk -f Lab5.awk Lab5.tr &
exec xgraph -P -bar -x TIME -y DATA gsm.xg &
exit 0
}
$ns at 0.0 "$ftp start"
$ns at 10.0 "End"
$ns run
