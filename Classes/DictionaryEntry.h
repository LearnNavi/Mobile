//
//  DictionaryEntry.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/19/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DictionaryEntry : NSObject {
	NSString *entryName;
	NSString *definition;
	NSString *type;
}

@property (nonatomic, copy) NSString *entryName, *definition, *type;

+ (id)entryWithName:(NSString *)entryName type:(NSString *)type andDefinition:(NSString *)definition;

@end
