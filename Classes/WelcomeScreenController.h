//
//  WelcomeScreenController.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/13/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WelcomeScreenController : UIViewController {
	
	UILabel *betaText;

}

@property (nonatomic, retain) IBOutlet UILabel *betaText;

- (NSString *)versionString;
- (NSString *)bundleShortVersionString;
- (NSString *)bundleVersionNumber;

@end
