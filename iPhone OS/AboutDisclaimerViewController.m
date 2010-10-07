//
//  AboutDisclaimerViewController.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 2/20/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import "AboutDisclaimerViewController.h"


@implementation AboutDisclaimerViewController

@synthesize contentText, contentTextShadow, bg_image, versionText;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(BOOL)contentType{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
		type = contentType;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [UIView beginAnimations:@"AboutDisclaimer" context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];
	[super viewWillAppear:animated];
	[UIView commitAnimations];
}




// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if(type){
		[self setupAbout];
		[[self versionText] setText:[self versionString]];
		[[self versionText] setHidden:NO];
	} else {
		[self setupDisclaimer];
		[[self versionText] setHidden:YES];
	}
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


- (void)dealloc {
    [super dealloc];
}

- (IBAction)doneReading:(id)sender {
	[self.navigationController popViewControllerAnimated:NO];
	
}

- (void)setupAbout {
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"AboutBackground" ofType:@"png"];
	[bg_image setImage:[UIImage imageWithContentsOfFile:path]];
	NSLog(@"Path: %@",path);
	[contentText setText:@"Learn Na'vi was created by Seze Ngrr from the Learn Na'vi online community.  It was created for the online community as a reference and learning tool.  Special thanks goes to Taronyu and Tuiq for providing the dictionary content and all the members from the Learn Na'vi online community that helped with the development process..."];
	[contentTextShadow setText:@"Learn Na'vi was created by Seze Ngrr from the Learn Na'vi online community.  It was created for the online community as a reference and learning tool.  Special thanks goes to Taronyu and Tuiq for providing the dictionary content and all the members from the Learn Na'vi online community that helped with the development process..."];
}

- (void)setupDisclaimer {

	NSString *path = [[NSBundle mainBundle] pathForResource:@"DisclaimerBackground" ofType:@"png"];
	[bg_image setImage:[UIImage imageWithContentsOfFile:path]];
	NSLog(@"Path: %@",path);
	[contentText setText:@"The Na'vi language was created by Paul Frommer. Much of the information displayed in this App was written by Prof. Frommer and is presented here for educational purposes only. Learn Na'vi is not affiliated with the official Avatar website, James Cameron, or the Twentieth Century-Fox Film Corporation. All trademarks and servicemarks are the properties of their respective owners."];
	[contentTextShadow setText:@"The Na'vi language was created by Paul Frommer. Much of the information displayed in this App was written by Prof. Frommer and is presented here for educational purposes only. Learn Na'vi is not affiliated with the official Avatar website, James Cameron, or the Twentieth Century-Fox Film Corporation. All trademarks and servicemarks are the properties of their respective owners."];
}

- (NSString *)bundleVersionNumber {
	return [[[NSBundle mainBundle] infoDictionary]
			valueForKey:@"CFBundleVersion"];
}

- (NSString *)bundleShortVersionString {
	return [[[NSBundle mainBundle] infoDictionary]
			valueForKey:@"SVN_Version"];
}

- (NSString *)versionString {
	//NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	//NSString *dictionary_version = [prefs stringForKey:@"database_version"];
	//NSString *dictionary_preupdate_version = [prefs stringForKey:@"database_pre-update_version"];
	//if (dictionary_preupdate_version == nil) {
	//	dictionary_preupdate_version = @"0";
	//	[prefs setObject:@"0" forKey:@"database_pre-update_version"];
	//}
	//return [NSString stringWithFormat:@"Version %@ (%@-%@-%@)",[self bundleVersionNumber], [self bundleShortVersionString], dictionary_version, dictionary_preupdate_version];
	return [NSString stringWithFormat:@"Version %@ (%@)",[self bundleVersionNumber], [self bundleShortVersionString]];//, [self bundleShortVersionString], dictionary_version, dictionary_preupdate_version];
	
}

@end
