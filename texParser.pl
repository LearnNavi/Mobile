#!/usr/bin/perl

open(MYINPUTFILE, "<NaviDictionary.tex");

while(<MYINPUTFILE>)
{
	my($line) = $_;
	chomp($line);

	if (
	$line =~ /\\(?:word|cww?|lenite|loan|derives)\{(.+?)\}\{(.+?)\}\{(.*?)\}\{(.+?)\}/
	#~ \note{s\`i}{sI}{conj.}{and}{connects two things: for clauses use}{ulte}{and}{S}
	|| $line =~/\\note\{(.+?)\}\{(.+?)\}\{(.+?)\}\{(.+?)\}\{(.+?)\}/) {
		#my ($navi, $ipa, $gender, $eng) = (quotemeta($1), $2, $3, quotemeta($4));
		my ($navi, $ipa, $gender, $eng) = ($1, $2, $3, $4);
		
		print "$navi,$gender,$eng\n";
	}
	
}