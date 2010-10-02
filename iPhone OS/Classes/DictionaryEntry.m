//
//  DictionaryEntry.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/19/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import "DictionaryEntry.h"


@implementation DictionaryEntry

@synthesize ID, version, navi, navi_no_specials, english_definition, infixes, part_of_speech, ipa, fancyType, alpha, beta;

+ (id)entryWithID:(NSString *)ID navi:(NSString *)navi navi_no_specials:(NSString *)navi_no_specials english_definition:(NSString *)english_definition infixes:(NSString *)infixes part_of_speech:(NSString *)part_of_speech ipa:(NSString *)ipa andFancyType:(NSString *)fancyType alpha:(NSString *)alpha beta:(NSString *)beta version:(int)version{
	DictionaryEntry *newEntry = [[[self alloc] init] autorelease];
	newEntry.ID = ID;
	newEntry.part_of_speech = part_of_speech;
	newEntry.english_definition = english_definition;
	newEntry.infixes = infixes;
	newEntry.ipa = ipa;
	newEntry.navi = navi;
	newEntry.navi_no_specials = navi_no_specials;
	newEntry.fancyType = fancyType;
	newEntry.alpha = alpha;
	newEntry.beta = beta;
	newEntry.version = version;
	return newEntry;
}


- (void) dealloc {
	[ID release];
	[navi release];
	[navi_no_specials release];
	[part_of_speech release];
	[english_definition release];
	[ipa release];
	[fancyType release];
	[alpha release];
	[beta release];
	[super dealloc];
}

int stringSort( id obj1, id obj2, void *context){
	NSString *entry1 = [(DictionaryEntry *)obj1 navi_no_specials];
	NSString *entry2 = [(DictionaryEntry *)obj2 navi_no_specials];
	
	return [entry1 compare:entry2 options:NSCaseInsensitiveSearch];
	
}
@end
