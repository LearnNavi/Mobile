//
//  DictionarySection.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/24/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import "DictionarySection.h"


@implementation DictionarySection

@synthesize sectionHeader, entries;

+ (id)sectionWithHeader:(NSString *)header andEntries:(NSMutableArray *)dictEntries {
	DictionarySection *newSection = [[[self alloc] init] autorelease];
	newSection.sectionHeader = header;
	newSection.entries = dictEntries;
	return newSection;
}

- (void)addEntry:(id)entry {
	[entries addObject:entry];
	
}

- (void) dealloc {
	[sectionHeader release];
	[entries release];
	
	[super dealloc];
}

@end
