//
//  AppViewController.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AppViewController : UIViewController {
	
	UILabel *betaText;
	UINavigationController *navController;
	DictionaryTableViewController *dictionaryTableViewController;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UILabel *betaText;
@property (nonatomic, retain) IBOutlet UIViewController *dictionaryTableViewController;

- (NSString *)versionString;
- (NSString *)bundleShortVersionString;
- (NSString *)bundleVersionNumber;

- (IBAction) launchDictionary:(id)sender;
- (IBAction) launchPhraseBook:(id)sender;
- (IBAction) launchPractice:(id)sender;

@end
