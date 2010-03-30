//
//  DictionaryEntry.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/19/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import "DictionaryEntry.h"


@implementation DictionaryEntry

@synthesize entryName, definition, type, fancyType;

+ (id)entryWithName:(NSString *)entryName type:(NSString *)type definition:(NSString *)definition andFancyType:(NSString *)fancyType {
	DictionaryEntry *newEntry = [[[self alloc] init] autorelease];
	newEntry.entryName = entryName;
	newEntry.type = type;
	newEntry.definition = definition;
	newEntry.fancyType = fancyType;
	return newEntry;
}

- (void) dealloc {
	[entryName release];
	[type release];
	[definition release];
	[super dealloc];
}

int stringSort( id obj1, id obj2, void *context){
	NSString *entry1 = [(DictionaryEntry *)obj1 entryName];
	NSString *entry2 = [(DictionaryEntry *)obj2 entryName];
	
	return [entry1 compare:entry2 options:NSCaseInsensitiveSearch];
	
}
@end
