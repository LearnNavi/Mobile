//
//  AppViewController.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DictionaryTableViewController.h"
#import "AppViewController.h"


@implementation AppViewController

@synthesize navController;
@synthesize betaText;
@synthesize dictionaryTableViewController;

- (NSString *)bundleVersionNumber {
	return [[[NSBundle mainBundle] infoDictionary]
			valueForKey:@"CFBundleVersion"];
}

- (NSString *)bundleShortVersionString {
	return [[[NSBundle mainBundle] infoDictionary]
			valueForKey:@"CFBundleShortVersionString"];
}

- (NSString *)versionString {
	
	return [NSString stringWithFormat:@"Version %@ (%@)",[self bundleShortVersionString] ,[self bundleVersionNumber]];
}


/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Update the App version string
	[betaText setText:[self versionString]];

}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated { 
	[super viewWillDisappear:animated];
	[navController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillAppear:(BOOL)animated { 
	[super viewWillAppear:animated];
	[navController setNavigationBarHidden:YES animated:YES];
	[navController setToolbarHidden:YES animated:YES];
}


- (void)dealloc {
	[navController release];
	
    [super dealloc];
}

- (IBAction) launchDictionary:(id)sender {
	NSLog(@"Start the Dictionary");
	if([self dictionaryTableViewController] == nil) {
		dictionaryTableViewController = [[DictionaryTableViewController alloc] initWithNibName:@"DictionaryTable" bundle:[NSBundle mainBundle]];
		
	}
	
	[[self navController] pushViewController:dictionaryTableViewController animated:YES];
	
	
}

- (IBAction) launchPhraseBook:(id)sender {
	NSLog(@"Start the Phrase Book");
	
}

- (IBAction) launchPractice:(id)sender {
	NSLog(@"Start the Practice");
	
}


@end
