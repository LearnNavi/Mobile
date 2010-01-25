//
//  DictionarySection.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DictionarySection : NSObject {
	NSString *sectionHeader;
	NSArray *entries;
}

@property (nonatomic, copy) NSString *sectionHeader;
@property (nonatomic, copy) NSArray *entries;

+ (id)sectionWithHeader:(NSString *)header andEntries:(NSArray *)dictEntries;

@end
