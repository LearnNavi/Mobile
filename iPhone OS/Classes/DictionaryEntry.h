//
//  DictionaryEntry.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/19/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DictionaryEntry : NSObject {
	NSString *entryName;
	NSString *navi_definition;
	NSString *english_definition;
	NSString *part_of_speech;
	NSString *ipa;
	NSString *imageURL;
	NSString *audioURL;
	NSString *fancyType;
	NSString *alpha;
	NSString *beta;
}

@property (nonatomic, copy) NSString *entryName, *navi_definition, *english_definition, *part_of_speech, *ipa, *imageURL, *audioURL, *fancyType, *alpha, *beta;

+ (id)entryWithName:(NSString *)entryName english_definition:(NSString *)english_definition navi_definition:(NSString *)navi_definition part_of_speech:(NSString *)part_of_speech ipa:(NSString *)ipa imageURL:(NSString *)imageURL audioURL:(NSString *)audioURL andFancyType:(NSString *)fancyType alpha:(NSString *)alpha beta:(NSString *)beta;
int stringSort( id obj1, id obj2, void *context);
@end
