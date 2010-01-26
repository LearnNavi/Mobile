//
//  Learn_Navi_iPhone_AppAppDelegate.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "Root.h"
#import "DictionaryTableViewController.h"
#import "Learn_Navi_iPhone_AppAppDelegate.h"
#import "AppViewController.h"
#import "FlurryAPI.h"

@implementation Learn_Navi_iPhone_AppAppDelegate

@synthesize window;

+(void)initialize { 
	
	//[[MMTrackingMgr sharedInstance] startDefaultTracking];

}

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
}

#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
		
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	//Tracking Code
	[FlurryAPI startSessionWithLocationServices:@"AIUXWAWDAFLHEUHXPUCC"];
	[FlurryAPI setSessionReportsOnCloseEnabled:YES];
	
	theRect = [[self window] frame];
	theRect = CGRectOffset(theRect, 0.0, 20.0);
	
	AppViewController *appViewController = [[AppViewController alloc] initWithNibName:@"AppViewController" bundle:[NSBundle mainBundle]];
	appViewController.view.frame = theRect;

	UINavigationController *thisNavigationController = [[UINavigationController alloc] initWithRootViewController:appViewController];
	thisNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	thisNavigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
	//thisNavigationController.navigationBar.autoresizesSubviews = NO;
	[thisNavigationController setNavigationBarHidden:YES];
	appViewController.navController = thisNavigationController;
	[window addSubview:appViewController.navigationController.view];
	[window makeKeyAndVisible];
	
}



/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    //Do any saving here
	
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    
	[window release];
	[super dealloc];
}


@end

