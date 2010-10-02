//
//  DictionaryEntry.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/19/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DictionaryEntry : NSObject {
	
	NSString *ID;
	NSString *navi;
	NSString *navi_no_specials;
	NSString *infixes;
	NSString *english_definition;
	NSString *part_of_speech;
	NSString *ipa;
	NSString *fancyType;
	NSString *alpha;
	NSString *beta;
	int version;
	
	
	
	}

@property (nonatomic, copy) NSString *ID, *navi, *navi_no_specials, *infixes, *english_definition, *part_of_speech, *ipa, *fancyType, *alpha, *beta;
@property (nonatomic) int version;
+ (id)entryWithID:(NSString *)ID navi:(NSString *)navi navi_no_specials:(NSString *)navi_no_specials english_definition:(NSString *)english_definition infixes:(NSString *)infixes part_of_speech:(NSString *)part_of_speech ipa:(NSString *)ipa andFancyType:(NSString *)fancyType alpha:(NSString *)alpha beta:(NSString *)beta version:(int)version;
int stringSort( id obj1, id obj2, void *context);
@end
