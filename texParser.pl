#!/usr/bin/perl

open(NAVIDICTIONARYFILE, "<NaviDictionary.tex");
open(ENGLISHDICTIONARYFILE, "<NaviEnglish.tex");

open(NAVICSVFILE, ">NaviDictionary.tsv");
open(ENGLISHCSVFILE, ">NaviEnglish.tsv");


while(<NAVIDICTIONARYFILE>)
{
	my($line) = $_;
	chomp($line);
	
	$line =~ s/\\\`i/ì/gi;
	$line =~ s/\\\"a/ä/gi;
	$line =~ s/\$_\{T\}\$//g;
	$line =~ s/\$<\$//g;
	$line =~ s/\$>\$//g;
	
	if (
	$line =~ /\\(?:word|cww?|lenite|loan|derives)\{(.+?)\}\{(.+?)\}\{(.*?)\}\{(.+?)\}/
	#~ \note{s\`i}{sI}{conj.}{and}{connects two things: for clauses use}{ulte}{and}{S}
	|| $line =~/\\note\{(.+?)\}\{(.+?)\}\{(.+?)\}\{(.+?)\}\{(.+?)\}/) {
		#my ($navi, $ipa, $gender, $eng) = (quotemeta($1), $2, $3, quotemeta($4));
		my ($navi, $ipa, $gender, $eng) = ($1, $2, $3, $4);
		
		print NAVICSVFILE "$navi<|>$gender<|>$eng\n";
	}
	
	if ( $line =~ /\\section\{Illegal Words\}/ ){
		print "Illegal Found\n";
		last;
	}
	
}

while(<ENGLISHDICTIONARYFILE>)
{
	my($line) = $_;
	chomp($line);
	
	$line =~ s/\\\`i/ì/gi;
	$line =~ s/\\\"a/ä/gi;
	$line =~ s/\$_\{T\}\$//g;
	$line =~ s/\$<\$//g;
	$line =~ s/\$>\$//g;
	
	if (
		$line =~ /\\(?:word|cww?|lenite|loan|derives)\{(.+?)\}\{(.+?)\}\{(.*?)\}\{(.+?)\}/
	#~ \note{s\`i}{sI}{conj.}{and}{connects two things: for clauses use}{ulte}{and}{S}
	|| $line =~/\\note\{(.+?)\}\{(.+?)\}\{(.+?)\}\{(.+?)\}\{(.+?)\}/) {
		#my ($navi, $ipa, $gender, $eng) = (quotemeta($1), $2, $3, quotemeta($4));
		my ($navi, $ipa, $gender, $eng) = ($1, $2, $3, $4);
		
		print ENGLISHCSVFILE "$navi<|>$gender<|>$eng\n";
	}
	
}

close (NAVICSVFILE);
close (ENGLISHCSVFILE);