#!/usr/bin/perl
use strict;
use warnings;

my $num = 5;
my %urls;
$urls{'xhr_get'} = "http://10.20.95.218/delay_test/xhr_get.php";


my %brs;
#brs{'chrome'} = "ch";
$brs{'firefox'} = "ff";
#$brs{'opera'} = "op";

my %cmds;
#$cmds{'chrome'} = "/usr/bin/google-chrome --allow-outdated-plugins --disk-cache-size=1 --media-cache-size=1 --incognito --always-authorize-plugins";
$cmds{'firefox'} = "firefox";
#$cmds{'opera'} = "opera";


#my $dir = "~/home/client/Documents/";

foreach my $k (keys(%brs)) {
	`mkdir $k`;
	my $client = $k."_ubuntu";
	foreach my $method (keys(%urls)) {
		#print "$method => $urls{$method}\n";
		my $url = $urls{$method}."?client=".$client;
		my $folder = $k.'/'.$method;
		`mkdir $folder`;
		
		for(my $i=0;$i<$num;$i++) {
			my $real_url = $url."&rd=".$i;
			my $cmd = "export DISPLAY=:0.0; ".$cmds{$k}." \"".$real_url."\" >/dev/null 2>&1 &";
			#print "$cmd\n";

			my $dump_f = $folder.'/'.$method.'_'.$k.'_'.$i.'.pcap';
			#print "$dump_f\n";
			
			my $tdcmd = "sudo tcpdump -i eno1 -s 65535 -w $dump_f tcp[20:2]=0x4854 or tcp[20:2]=0x4745 and ip host 10.20.95.218 and ip host 192.168.109.25 >/dev/null 2>&1 &";
			print "$tdcmd\n";
			`$tdcmd`;					

			sleep(3);
			print "$cmd\n";
			`$cmd`;
			
			sleep(8);
			my $killcmd1 = "sudo killall $k";
			print "$killcmd1\n";
			`$killcmd1`;
			
			sleep(1);
			my $killcmd2 = "sudo killall tcpdump";
			print "$killcmd2\n\n";
			`$killcmd2`;
			
			sleep(2);
		}
		 for(my $i=0;$i<$num;$i++) {	
			my $dump_f = $folder.'/'.$method.'_'.$k.'_'.$i.'.pcap';
			my $timestamp_f = $folder.'/'.'timestamp'.$i.'.csv';
			my $timecmd="tshark -r $dump_f -T fields -e frame.time_epoch -e ip.src -e ip.dst -e ptp.v2.sdr.origintimestamp.seconds -E separator=,> $timestamp_f";
			#print "$timecmd\n";
			`$timecmd`;

		}
	}
}
