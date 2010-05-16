//
//  ResourcesViewController.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 2/20/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AboutDisclaimerViewController.h"

@interface ResourcesViewController : UIViewController {
	AboutDisclaimerViewController *about;
	AboutDisclaimerViewController *disclaimer;
	BOOL shouldAnimate;
}

@property (nonatomic, retain) IBOutlet UIViewController *about, *disclaimer;

- (IBAction)returnHome:(id)sender;
- (IBAction)launchLearnNaviSite:(id)sender;
- (IBAction)updateDictionary:(id)sender;
- (IBAction)disclaimer:(id)sender;
- (IBAction)about:(id)sender;

@end
