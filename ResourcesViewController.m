//
//  ResourcesViewController.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 2/20/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import "ResourcesViewController.h"
#import "AboutDisclaimerViewController.h"


@implementation ResourcesViewController

@synthesize about, disclaimer;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		shouldAnimate = NO;
    }
    return self;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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

- (void)viewWillAppear:(BOOL)animated {
    if(shouldAnimate){
		[UIView beginAnimations:@"AboutDisclaimer" context:nil];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
		[super viewWillAppear:animated];
		[UIView commitAnimations];
		shouldAnimate = NO;
	} else {
		[super viewWillAppear:animated];
	}
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

- (IBAction)returnHome:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
	
}

- (IBAction)launchLearnNaviSite:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.learnnavi.org"]];
	
}

- (IBAction)disclaimer:(id)sender {
	
	if([self disclaimer] == nil) {
		disclaimer = [[AboutDisclaimerViewController alloc] initWithNibName:@"AboutDisclaimerViewController" bundle:[NSBundle mainBundle] type:NO];
	}
	shouldAnimate = YES;
	[[self navigationController] pushViewController:disclaimer animated:NO];
}

- (IBAction)about:(id)sender {
	if([self about] == nil) {
		about = [[AboutDisclaimerViewController alloc] initWithNibName:@"AboutDisclaimerViewController" bundle:[NSBundle mainBundle] type:YES];
	}
	shouldAnimate = YES;
	[[self navigationController] pushViewController:about animated:NO];
	
}



@end
