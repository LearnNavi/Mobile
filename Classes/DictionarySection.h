//
//  DictionarySection.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/24/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DictionarySection : NSObject {
	NSString *sectionHeader;
	NSMutableArray *entries;
}

@property (nonatomic, copy) NSString *sectionHeader;
@property (nonatomic, retain) NSMutableArray *entries;

+ (id)sectionWithHeader:(NSString *)header andEntries:(NSMutableArray *)dictEntries;
- (void)addEntry:(id)entry;
@end
