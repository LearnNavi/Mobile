//
//  DictionaryEntry.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/19/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import "DictionaryEntry.h"


@implementation DictionaryEntry

@synthesize entryName, english_definition, navi_definition, part_of_speech, ipa, imageURL, audioURL, fancyType, alpha, beta;

+ (id)entryWithName:(NSString *)entryName english_definition:(NSString *)english_definition navi_definition:(NSString *)navi_definition part_of_speech:(NSString *)part_of_speech ipa:(NSString *)ipa imageURL:(NSString *)imageURL audioURL:(NSString *)audioURL andFancyType:(NSString *)fancyType alpha:(NSString *)alpha beta:(NSString *)beta {
	DictionaryEntry *newEntry = [[[self alloc] init] autorelease];
	newEntry.entryName = entryName;
	newEntry.part_of_speech = part_of_speech;
	newEntry.english_definition = english_definition;
	newEntry.navi_definition = navi_definition;
	newEntry.ipa = ipa;
	newEntry.imageURL = imageURL;
	newEntry.audioURL = audioURL;
	newEntry.fancyType = fancyType;
	newEntry.alpha = alpha;
	newEntry.beta = beta;
	return newEntry;
}

- (void) dealloc {
	[entryName release];
	[part_of_speech release];
	[english_definition release];
	[navi_definition release];
	[ipa release];
	[imageURL release];
	[audioURL release];
	[fancyType release];
	[alpha release];
	[beta release];
	[super dealloc];
}

int stringSort( id obj1, id obj2, void *context){
	NSString *entry1 = [(DictionaryEntry *)obj1 entryName];
	NSString *entry2 = [(DictionaryEntry *)obj2 entryName];
	
	return [entry1 compare:entry2 options:NSCaseInsensitiveSearch];
	
}
@end
