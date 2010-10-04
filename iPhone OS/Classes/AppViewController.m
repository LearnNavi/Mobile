//
//  AppViewController.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import "ResourcesViewController.h"
#import "DictionaryTableViewController.h"
#import "languageGuideViewController.h"
#import "AppViewController.h"
#import "FlurryAPI.h"


@implementation AppViewController

@synthesize navController;
@synthesize betaText;
@synthesize dictionaryTableViewController, resources, languageGuideController;

- (NSString *)bundleVersionNumber {
	return [[[NSBundle mainBundle] infoDictionary]
			valueForKey:@"CFBundleVersion"];
}

- (NSString *)bundleShortVersionString {
	return [[[NSBundle mainBundle] infoDictionary]
			valueForKey:@"SVN_Version"];
}

- (NSString *)versionString {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *dictionary_version = [prefs stringForKey:@"database_version"];
	NSString *dictionary_preupdate_version = [prefs stringForKey:@"database_pre-update_version"];
	if (dictionary_preupdate_version == nil) {
		dictionary_preupdate_version = @"0";
		[prefs setObject:@"0" forKey:@"database_pre-update_version"];
	}
	return [NSString stringWithFormat:@"Version %@ (%@-%@-%@)",[self bundleVersionNumber], [self bundleShortVersionString], dictionary_version, dictionary_preupdate_version];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Update the App version string
	NSLog(@"%@", [self versionString]);
	[betaText setText:[self versionString]];

}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated { 
	[super viewWillAppear:animated];
	//Whenever this view shows up, we hide the navigationbar and the toolbar
	[navController setNavigationBarHidden:YES animated:YES];
	[navController setToolbarHidden:YES animated:YES];
}


- (void)dealloc {
	[navController release];
	
    [super dealloc];
}

- (IBAction) launchDictionary:(id)sender {
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *mode = [prefs stringForKey:@"dictionary_language"];
	BOOL currentMode;
	if([mode compare:@"navi"] == 0){
		currentMode = YES;
	} else if([mode compare:@"english"] == 0){
		currentMode = NO;
	} else {
		NSLog(@"Unknown mode: %@", mode);
		currentMode = YES;
	}
	if([self dictionaryTableViewController] == nil) {
		dictionaryTableViewController = [[DictionaryTableViewController alloc] initWithNibName:@"DictionaryTable" bundle:[NSBundle mainBundle]];
		if(currentMode){
			self.navigationItem.backBarButtonItem =
			[[UIBarButtonItem alloc] initWithTitle:@"Kelutral"
											 style: UIBarButtonItemStyleBordered
											target:nil
											action:nil];
		} else {
			self.navigationItem.backBarButtonItem =
			[[UIBarButtonItem alloc] initWithTitle:@"Home"
											 style: UIBarButtonItemStyleBordered
											target:nil
											action:nil];
			
		}
	}	
	
	
	
	[[self navController] pushViewController:dictionaryTableViewController animated:YES];
	
}

- (IBAction) launchPhraseBook:(id)sender {
	
	
	NSLog(@"Start the Phrase Book");
	
}

- (IBAction) launchPractice:(id)sender {
	
	
	NSLog(@"Start the Practice");
	
}

- (IBAction) launchNaviLanguage:(id)sender {
	
	
	if([self languageGuideController] == nil) {
		languageGuideController = [[languageGuideViewController alloc] initWithNibName:@"languageGuideViewController" bundle:[NSBundle mainBundle]];
		
	}
	
	[[self navController] pushViewController:languageGuideController animated:YES];
	
}

- (IBAction) launchResources:(id)sender {
	
	
	if([self resources] == nil) {
		resources = [[ResourcesViewController alloc] initWithNibName:@"ResourcesViewController" bundle:[NSBundle mainBundle]];
		
	}
	
	[[self navController] pushViewController:resources animated:YES];
}


@end
