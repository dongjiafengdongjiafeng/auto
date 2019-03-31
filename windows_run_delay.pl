#!perl -w
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
$brs{'safari'} = "sa";
$brs{'ie'} = "ie";

my %cmds;
$cmds{'firefox'} = "start firefox.exe";
$cmds{'chrome'} = "start chrome.exe --allow-outdated-plugins --disk-cache-size=1 --media-cache-size=1 --incognito";
$cmds{'opera'} = "start opera.exe";
$cmds{'safari'} = "start Safari.exe";
$cmds{'ie'} = "start iexplore.exe";

my %exes;
$exes{'firefox'} = "firefox.exe";
$exes{'chrome'} = "chrome.exe";
$exes{'opera'} = "opera.exe";
$exes{'safari'} = "Safari.exe";
$exes{'ie'} = "iexplore.exe";

my $dir = "~/browser_test/windows/";

foreach my $k (keys(%brs)) {
	system("mkdir $k");
	foreach my $method (keys(%urls)) {
		my $folder = $k.'\\'.$method;
		system("mkdir $folder");
		
		for(my $i=0;$i<$num;$i++) {
			my $client = $k."_win";
			my $real_url = $urls{$method}."?client=".$client."&rd=".$i;
			
			my $cmd = $cmds{$k}." \"".$real_url."\"";
			print $cmd."\n";
			
			my $dump_f = $folder.'\\'.$method.'_'.$k.'_'.$i.'.pcap';
			#print "$dump_f\n";
			
			my $dump_cmd = "start windump.exe -i \\Device\\NPF_\{53460B2E-7BA5-4198-A436-06398ACE2227\} -w $dump_f -s 0 host 158.132.255.32";
			#print "$dump_cmd\n";
			
			#start windump
			system($dump_cmd);
			sleep(3);
			
			#open browser
			system($cmd);
			sleep(8);
			
			#kill browser
			my $killcmd1 = "start taskkill.exe /IM ".$exes{$k};
			print "$killcmd1\n";
			system($killcmd1);
			sleep(1);
			
			#kill windump
			my $killcmd2 = "start taskkill.exe /IM windump.exe";
			print "$killcmd2\n";
			system($killcmd2);
			sleep(2);
		}
	}
}