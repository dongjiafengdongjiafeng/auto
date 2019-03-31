#!/usr/bin/perl
use strict;
use warnings;

my $num = 50;
my %urls;
$urls{'xhr_get'} = "http://158.132.255.32:25001/thumb/delay_test/xhr_get.php";
$urls{'xhr_post'} = "http://158.132.255.32:25001/thumb/delay_test/xhr_post.php";
$urls{'xss'} = "http://158.132.255.32:25001/thumb/delay_test/xss.php";
$urls{'dom_post'} = "http://158.132.255.32:25001/thumb/delay_test/dom_post.htm";
$urls{'websocket'} = "http://158.132.255.32:25001/thumb/delay_test/wsclient.htm";

$urls{'flash_socket'} = "http://158.132.255.32:25001/thumb/delay_test/fl_socket.php";
$urls{'flash_get'} = "http://158.132.255.32:25001/thumb/delay_test/fl_get.php";
$urls{'flash_post'} = "http://158.132.255.32:25001/thumb/delay_test/fl_post.php";

$urls{'java_tcp'} = "http://158.132.255.32:25001/thumb/delay_test/ja_tcp.php";
$urls{'java_get'} = "http://158.132.255.32:25001/thumb/delay_test/ja_get.php";
$urls{'java_post'} = "http://158.132.255.32:25001/thumb/delay_test/ja_post.php";

my %brs;
$brs{'firefox'} = "ff";
$brs{'chrome'} = "ch";
$brs{'opera'} = "op";

my %cmds;
$cmds{'firefox'} = "firefox";
$cmds{'chrome'} = "/opt/google/chrome/google-chrome --allow-outdated-plugins --disk-cache-size=1 --media-cache-size=1 --incognito --always-authorize-plugins";
$cmds{'opera'} = "opera";

#my $dir = "~/browser_test/delay_test/";

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
			
			my $dump_f = $folder.'/'.$method.'_'.$k.'_'.$i.'.pcap';
			#print "$dump_f\n";
			
			my $tdcmd = "sudo nohup tcpdump -i eth1 -s 65535 -w $dump_f tcp and host 158.132.255.32 >/dev/null 2>&1 &";
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
	}
}