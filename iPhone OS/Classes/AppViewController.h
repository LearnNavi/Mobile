//
//  AppViewController.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourcesViewController.h"
#import "languageGuideViewController.h"


@interface AppViewController : UIViewController {
	
	ResourcesViewController *resources;
	UILabel *betaText;
	UINavigationController *navController;
	DictionaryTableViewController *dictionaryTableViewController;
	languageGuideViewController *languageGuideController;
}

@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UILabel *betaText;
@property (nonatomic, retain) IBOutlet UIViewController *dictionaryTableViewController;
@property (nonatomic, retain) IBOutlet UIViewController *resources, *languageGuideController;

- (NSString *)versionString;
- (NSString *)bundleShortVersionString;
- (NSString *)bundleVersionNumber;

- (IBAction) launchDictionary:(id)sender;
- (IBAction) launchPhraseBook:(id)sender;
- (IBAction) launchPractice:(id)sender;
- (IBAction) launchResources:(id)sender;
- (IBAction) launchNaviLanguage:(id)sender;

@end
