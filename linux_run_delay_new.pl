#!/usr/bin/perl
use strict;
use warnings;

my $num =50;
my %urls;
#$urls{'xhr_get'} = "http://192.168.0.5/xhr_get.php";
#$urls{'xhr_post'} = "http://192.168.0.5/xhr_post.php";
$urls{'ws'} = "http://192.168.0.10/wsclient.php";


my %brs;
#$brs{'chrome'} = "ch";
$brs{'firefox'} = "ff";
#$brs{'opera'} = "op";

my %cmds;
#$cmds{'chrome'} = "/usr/bin/google-chrome-stable --allow-outdated-plugins --disk-cache-size=1 --media-cache-size=1 --incognito --always-authorize-plugins";
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
			
			my $timestamp_f = $folder.'/'.'timestamp'.'_'.$method.'_'.$k.'.csv';

			my $tdcmd = "sudo tshark -s 65535 -i eno1 -Y 'http or websocket and ip.host==192.168.0.5' -T fields -e frame.time_epoch -e ip.src -e ip.dst  -E separator=,>> $timestamp_f &";
			print "$tdcmd\n";
			`$tdcmd`;					

			sleep(1);
			print "$cmd\n";
			`$cmd`;
			
			sleep(2);
			my $killcmd1 = "sudo killall $k";
			print "$killcmd1\n";
			`$killcmd1`;
			
			sleep(2);
			my $killcmd2 = "sudo killall tshark";
			print "$killcmd2\n\n";
			`$killcmd2`;
			
			sleep(1);
		}
		 
	}
}
