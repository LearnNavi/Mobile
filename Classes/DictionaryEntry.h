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
	NSString *definition;
	NSString *type;
	NSString *fancyType;
}

@property (nonatomic, copy) NSString *entryName, *definition, *type, *fancyType;

+ (id)entryWithName:(NSString *)entryName type:(NSString *)type definition:(NSString *)definition andFancyType:(NSString *)fancyType;

@end
