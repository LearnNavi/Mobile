//
//  DictionaryViewController.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DictionaryTableViewController.h"
#import "DictionaryViewController.h"
#import "DictionaryEntry.h"
#import "Learn_Navi_iPhone_AppAppDelegate.h"

@implementation DictionaryViewController

@synthesize tableView, tableController;

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
    self.title = @"Na'vi Dictionary";
	self.tableController = [[DictionaryTableViewController alloc] initWithNibName:@"DictionaryTable" bundle:[NSBundle mainBundle]];
	[self.tableController addViewController:self];
	[self.tableView addSubview:self.tableController.view];
	
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

- (void) dictionaryEntrySelected:(DictionaryEntry *)entry {
	//NSLog([entry entryName]);
	UIViewController *detailsViewController = [[UIViewController alloc] init];
	detailsViewController.title = entry.entryName;
	[[self navigationController] pushViewController:detailsViewController animated:YES];
	[detailsViewController release];
}


- (void)dealloc {
	
	
    [super dealloc];
}

- (IBAction) goHome:(id)sender {
	[[self view] removeFromSuperview];
}






@end
