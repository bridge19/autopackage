#!/usr/bin/perl


use Getopt::Std;
use utf8;
use Encode;
use XML::Simple;
binmode(STDIN, ':encoding(utf8)');
binmode(STDOUT, ':encoding(utf8)');
binmode(STDERR, ':encoding(utf8)');

use vars qw($opt_a $opt_b);
getopts('a:b:');


my $xmlfile = "$opt_a";
open OUTFILE,">$opt_b";

my $casesT = XML::Simple->new( ForceArray => 1 );
my $caseT  = $casesT->XMLin($xmlfile);

my @cT = @{ $caseT->{"logentry"} };

printf OUTFILE ("|%-8s |%-12s |%-12s |%s\n","Version","Owner","Date","Comments");

foreach my $c (@cT) {
	
	$revision = $c->{"revision"};
	$author = $c->{"author"}[0];
	$date   = $c->{"date"}[0];

	$msg = $c->{"msg"}[0];
	if (substr($msg,0,4) eq "HASH") 
	{
		$msg="";
	}
	printf OUTFILE ("|%-8s |%-12s |%-12s |%s\n",$revision,$author,substr("$date", 0,10),$msg);

}