//
//  Learn_Navi_iPhone_AppAppDelegate.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/8/10.
//  Copyright LearnNa'vi.org Community 2010. All rights reserved.
//

#import "Root.h"
#import "DictionaryTableViewController.h"
#import "Learn_Navi_iPhone_AppAppDelegate.h"
#import "AppViewController.h"
#import "FlurryAPI.h"
#import "LoadingView.h"

@implementation Learn_Navi_iPhone_AppAppDelegate

@synthesize window, appViewController;

+(void)initialize { 
	
	//[[MMTrackingMgr sharedInstance] startDefaultTracking];

}

void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAPI logError:@"Uncaught" message:@"Crash!" exception:exception];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	if(launchOptions != nil){
		NSLog(@"Update Database");
		[self startUpdate:self];
		
	}
    
	
	
	
	// Override point for customization after app launch 
	
	NSString *filter1 = [[NSUserDefaults standardUserDefaults] stringForKey:@"filter1"];
	
	// Note: this will not work for boolean values as noted by bpapa below.
	// If you use booleans, you should use objectForKey above and check for null
	if(!filter1) {
		[self registerDefaultsFromSettingsBundle];
	}
	[self checkAndCreateDatabase];
	
	
	// Add registration for remote notifications
	[[UIApplication sharedApplication] 
	 registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	
	// Clear application badge when app launches
	application.applicationIconBadgeNumber = 0;
	
	
	
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
	//Tracking Code
	[FlurryAPI startSessionWithLocationServices:@"AIUXWAWDAFLHEUHXPUCC"];
	[FlurryAPI setSessionReportsOnCloseEnabled:YES];
	[self launchApp:self];
	
	return NO;
}



- (void)launchApp:(id)sender {
	
	theRect = [[self window] frame];
	theRect = CGRectOffset(theRect, 0.0, 20.0);
	
	if(appViewController) {
		[appViewController.navigationController.view removeFromSuperview];
		[appViewController release];
		
	}
	appViewController = [[AppViewController alloc] initWithNibName:@"AppViewController" bundle:[NSBundle mainBundle]];
	appViewController.view.frame = theRect;
	
	UINavigationController *thisNavigationController = [[UINavigationController alloc] initWithRootViewController:appViewController];
	thisNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	thisNavigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
	//thisNavigationController.navigationBar.autoresizesSubviews = NO;
	[thisNavigationController setNavigationBarHidden:YES];
	appViewController.navController = thisNavigationController;
	[window addSubview:appViewController.navigationController.view];
	[window makeKeyAndVisible];
	[self performSelectorInBackground:@selector(checkDatabaseVersion:) withObject:nil];

}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken {
	
#if !TARGET_IPHONE_SIMULATOR
	
	//NSLog(@"%@",devToken); 
	// Get Bundle Info for Remote Registration (handy if you have more than one app)
	NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
	NSString *appVersion = [self versionString];
	
	// Check what Notifications the user has turned on.  We registered for all three, but they may have manually disabled some or all of them.
	NSUInteger rntypes = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
	
	// Set the defaults to disabled unless we find otherwise...
	NSString *pushBadge = @"disabled";
	NSString *pushAlert = @"disabled";
	NSString *pushSound = @"disabled";
	
	// Check what Registered Types are turned on. This is a bit tricky since if two are enabled, and one is off, it will return a number 2... not telling you which
	// one is actually disabled. So we are literally checking to see if rnTypes matches what is turned on, instead of by number. The "tricky" part is that the 
	// single notification types will only match if they are the ONLY one enabled.  Likewise, when we are checking for a pair of notifications, it will only be 
	// true if those two notifications are on.  This is why the code is written this way ;)
	if(rntypes == UIRemoteNotificationTypeBadge){
		pushBadge = @"enabled";
	}
	else if(rntypes == UIRemoteNotificationTypeAlert){
		pushAlert = @"enabled";
	}
	else if(rntypes == UIRemoteNotificationTypeSound){
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert)){
		pushBadge = @"enabled";
		pushAlert = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)){
		pushBadge = @"enabled";
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
		pushAlert = @"enabled";
		pushSound = @"enabled";
	}
	else if(rntypes == ( UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)){
		pushBadge = @"enabled";
		pushAlert = @"enabled";
		pushSound = @"enabled";
	}
	
	// Get the users Device Model, Display Name, Unique ID, Token & Version Number
	UIDevice *dev = [UIDevice currentDevice];
	NSString *deviceUuid = dev.uniqueIdentifier;
    NSString *deviceName = dev.name;
	NSString *deviceModel = dev.model;
	NSString *deviceSystemVersion = dev.systemVersion;
	
	// Prepare the Device Token for Registration (remove spaces and < >)
	NSString *deviceToken = [[[[devToken description] 
							   stringByReplacingOccurrencesOfString:@"<"withString:@""] 
							  stringByReplacingOccurrencesOfString:@">" withString:@""] 
							 stringByReplacingOccurrencesOfString: @" " withString: @""];
	
	// Build URL String for Registration
	// !!! CHANGE "www.mywebsite.com" TO YOUR WEBSITE. Leave out the http://
	// !!! SAMPLE: "secure.awesomeapp.com"
	NSString *host = @"www.learnnaviapp.com";
	
	// !!! CHANGE "/apns.php?" TO THE PATH TO WHERE apns.php IS INSTALLED 
	// !!! ( MUST START WITH / AND END WITH ? ). 
	// !!! SAMPLE: "/path/to/apns.php?"
	NSString *urlString = [NSString stringWithFormat:@"/apns/apns.php?task=%@&appname=%@&appversion=%@&deviceuid=%@&devicetoken=%@&devicename=%@&devicemodel=%@&deviceversion=%@&pushbadge=%@&pushalert=%@&pushsound=%@", @"register", appName,appVersion, deviceUuid, deviceToken, deviceName, deviceModel, deviceSystemVersion, pushBadge, pushAlert, pushSound];
	
	// Register the Device Data
	// !!! CHANGE "http" TO "https" IF YOU ARE USING HTTPS PROTOCOL
	NSURL *url = [[NSURL alloc] initWithScheme:@"http" host:host path:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
	NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	returnData;
	//NSLog(@"Register URL: %@", url);
	//NSLog(@"Return Data: %@", returnData);
	
#endif
}

/**
 * Failed to Register for Remote Notifications
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	
#if !TARGET_IPHONE_SIMULATOR
	
	NSLog(@"Error in registration. Error: %@", error);
	
#endif
}

/**
 * Remote Notification Received while application was open.
 */
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	
#if !TARGET_IPHONE_SIMULATOR
    
	NSLog(@"remote notification: %@",[userInfo description]);
	NSDictionary *apsInfo = [userInfo objectForKey:@"aps"];
	
	NSString *alert = [apsInfo objectForKey:@"alert"];
	NSLog(@"Received Push Alert: %@", alert);
	
	NSString *sound = [apsInfo objectForKey:@"sound"];
	NSLog(@"Received Push Sound: %@", sound);
	//AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
	
	NSString *badge = [apsInfo objectForKey:@"badge"];
	NSLog(@"Received Push Badge: %@", badge);
	application.applicationIconBadgeNumber = [[apsInfo objectForKey:@"badge"] integerValue];
	
#endif
}



- (void)registerDefaultsFromSettingsBundle {
	NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
	if(!settingsBundle) {
		NSLog(@"Could not find Settings.bundle");
		return;
	}
	
	NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
	NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
	
	NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
	for(NSDictionary *prefSpecification in preferences) {
		NSString *key = [prefSpecification objectForKey:@"Key"];
		if(key) {
			[defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
		}
	}
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
	[defaultsToRegister release];
}



/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	
    //Do any saving here
	
}

- (void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	NSString *databaseName = @"dictionary.sqlite";
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	//NSString *databasePathTemp = [databasePath stringByAppendingString:@".temp"];
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	// If the database already exists then return without doing anything
	if(success) {
		//We know a database exists, but it may be outdated, check for database version
		//[fileManager copyItemAtPath:databasePathFromApp toPath:databasePathTemp error:nil];
		
		//[fileManager release];
		
		double versionCurrent = [self getDatabaseVersion:databasePath];
		double versionNew = [self getDatabaseVersion:databasePathFromApp];
		
		if(versionNew > versionCurrent){
			//needs updated
			NSLog(@"Updating database to version: %f", versionNew);
			NSError *err;
			[fileManager removeItemAtPath:databasePath error:nil];
			[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:&err];
			
			
			
		} else {
			//Up to date
			
		}
		
		
	} else {
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	
		[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
		
	}
	// Copy the database from the package to the users filesystem
	
	[self registerDatabaseInfo:databasePath];
	
	[fileManager release];
	return;

}

- (void) checkDatabaseVersion:(id)sender{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	NSString *databaseName = @"dictionary.sqlite";
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	
	double databaseVersion = [self getDatabaseVersion:databasePath];
	
	// Check the web for updates to the database, if enabled
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES; // to stop it, set this to NO
	
	NSError *errVersion = [[[NSError alloc] init] autorelease];
	NSString *versionUrl = [[NSString stringWithFormat:@"http://learnnaviapp.com/database/version"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *versionFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:versionUrl] encoding:NSUTF8StringEncoding error:&errVersion];
	if(errVersion.code != 0) {
		// HANDLE ERROR HERE
		NSLog(@"Online Error: %@", [errVersion localizedDescription]);
	} else {
		NSLog(@"Online Version: %@", versionFile);
		
		if(databaseVersion < [versionFile doubleValue]){
			// New database available
			// Prompt user to download new version
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dictionary Update Ready" message:@"There is a new version of the dictionary available for download.  Would you like to update now?" 
														   delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
			[alert show];
			[alert release];
			
			
			
		} else {
			NSLog(@"Up to date");
			
		}
		
		
		
	}
	
	
	app.networkActivityIndicatorVisible = NO;
	
	
	
	
	
	
	[self registerDatabaseInfo:databasePath];
	[pool release];
	return;
	
}


- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (buttonIndex == 1)
	{
		NSLog(@"Yes");
		[self startUpdate:self];
		
	}
	else
	{
		NSLog(@"User canceled database update");
	}
}

- (void)startUpdate:(id)sender {
	loadingView =
	[LoadingView loadingViewInView:[self window]];
	[self performSelectorInBackground:@selector(updateDatabase:) withObject:nil];

}

- (void)updateFinished:(id)sender {
	
	[loadingView removeView];
	[self launchApp:self];
}

- (void)updateDatabase:(id)sender {
	
	
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	
	// Download new version
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES; // to stop it, set this to NO
	
	NSString *databaseUrl = [[NSString stringWithFormat:@"http://learnnaviapp.com/database/dictionary.sqlite"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSData *newDatabase = [NSData dataWithContentsOfURL:[NSURL URLWithString:databaseUrl]];
	
	if(newDatabase == nil){
		NSLog(@"Error downloading database");
		
	} else {
		//Delete current database
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		NSString *databaseName = @"dictionary.sqlite";
		
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
		
		[fileManager removeItemAtPath:databasePath error:nil];
		[fileManager createFileAtPath:databasePath contents:newDatabase attributes:nil];
		
		[fileManager release];
		[self registerDatabaseInfo:databasePath];
		app.networkActivityIndicatorVisible = NO;
		
		
		// Show success message
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dictionary Updated" message:@"The dictionary has been successfully updated." 
													   delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	//[NSThread sleepForTimeInterval:1.0];
	[self performSelectorOnMainThread:@selector(updateFinished:) withObject:nil waitUntilDone:YES];
	
	[pool release];
	
}

- (double)getDatabaseVersion:(NSString *)aDatabase {
	sqlite3 *dBase;
	if(sqlite3_open([aDatabase UTF8String], &dBase) != SQLITE_OK) {
		NSLog(@"Error read version");
		return 0;
	} 
	NSString *versionString;
	const char *sqlStatement = "select version from version";
	sqlite3_stmt *compiledStatement;
	if(sqlite3_prepare_v2(dBase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			versionString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			//NSLog(@"Version: %@",versionString);
		}
	} else {
		NSLog(@"Error read version 2: %@", aDatabase);
		return 0;
	}
	// Release the compiled statement from memory
	sqlite3_finalize(compiledStatement);
	
	
	sqlite3_close(dBase);
	
	return [versionString doubleValue];
	
}

- (void)registerDatabaseInfo:(NSString *)aDatabase {
	sqlite3 *dBase;
	if(sqlite3_open([aDatabase UTF8String], &dBase) != SQLITE_OK) {
		NSLog(@"Error read version");
		return;
	} 
	NSString *versionString;
	NSString *dictionaryVersionString;
	NSString *dateString;
	
	const char *sqlStatement = "select version,dictionary_version,date from version";
	sqlite3_stmt *compiledStatement;
	if(sqlite3_prepare_v2(dBase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			versionString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			dictionaryVersionString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
			dateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
			//NSLog(@"Version: %@",versionString);
		}
	} else {
		NSLog(@"Error read version 2: %@", aDatabase);
		return;
	}
	// Release the compiled statement from memory
	sqlite3_finalize(compiledStatement);
	
	
	sqlite3_close(dBase);
	
	//Register settings
	
	[[NSUserDefaults standardUserDefaults]
	 setObject:dictionaryVersionString forKey:@"dictionary_version"];
	[[NSUserDefaults standardUserDefaults]
	 setObject:versionString forKey:@"database_version"];
	[[NSUserDefaults standardUserDefaults]
	 setObject:dateString forKey:@"dictionary_date"];
	
	
	
	return ;
	
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
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSString *dictionary_version = [prefs stringForKey:@"database_version"];
	return [NSString stringWithFormat:@"Version %@ (%@-%@)",[self bundleVersionNumber], [self bundleShortVersionString], dictionary_version];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    
	[window release];
	[super dealloc];
}


@end

