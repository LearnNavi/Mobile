//
//  DictionaryEntry.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DictionaryEntry.h"


@implementation DictionaryEntry

@synthesize entryName, definition, type;

+ (id)entryWithName:(NSString *)entryName type:(NSString *)type andDefinition:(NSString *)definition {
	DictionaryEntry *newEntry = [[[self alloc] init] autorelease];
	newEntry.entryName = entryName;
	newEntry.type = type;
	newEntry.definition = definition;
	return newEntry;
}

- (void) dealloc {
	[entryName release];
	[type release];
	[definition release];
	[super dealloc];
}

@end
