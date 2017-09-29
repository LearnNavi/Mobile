//
//  LearnNaviAppDelegate.m
//  Learn Navi iPhone App
//
//  Created by Zoë Snow on 1/8/10.
//  Copyright LearnNa'vi.org Community 2010. All rights reserved.
//

//#import "Root.h"
#import "DictionaryTableViewController.h"
#import "LearnNaviAppDelegate.h"
#import "AppViewController.h"
#import "LoadingView.h"

@implementation LearnNaviAppDelegate

@synthesize window, appViewController;

+(void)initialize {

}

void uncaughtExceptionHandler(NSException *exception) {
    
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
	
	// Clear application badge when app launches
	application.applicationIconBadgeNumber = 0;
	NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    UINavigationController *rootNavigationController = (UINavigationController *)self.window.rootViewController;
    AppViewController *appViewController = (AppViewController *)[rootNavigationController topViewController];
	
	rootNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	rootNavigationController.toolbar.barStyle = UIBarStyleBlackOpaque;
	//rootNavigationController.navigationBar.autoresizesSubviews = NO;
	[rootNavigationController setNavigationBarHidden:YES];
	appViewController.navController = rootNavigationController;
    if ([window respondsToSelector:@selector(setRootViewController:)]) {
        window.rootViewController = appViewController.navigationController;
    } else {
        [window addSubview:appViewController.navigationController.view];
    }
	[window addSubview:appViewController.navigationController.view];
	//[window makeKeyAndVisible];
    
    [self performSelectorInBackground:@selector(checkDatabaseVersion:) withObject:nil];
	return YES;
}

- (void)launchApp:(id)sender {

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
	NSString *databaseName = @"database.sqlite";
	
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
	NSString *databaseName = @"database.sqlite";
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
	double databaseVersion = [self getDatabaseVersion:databasePath];
	
	// Check the web for updates to the database, if enabled
	UIApplication* app = [UIApplication sharedApplication];

    dispatch_async(dispatch_get_main_queue(), ^{
        app.networkActivityIndicatorVisible = YES; // to stop it, set this to NO
    });
	
	
	NSError *errVersion = [[[NSError alloc] init] autorelease];
	NSString *versionUrl = [[NSString stringWithFormat:@"https://files.learnnavi.org/mobile/database.version"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *versionFile = [NSString stringWithContentsOfURL:[NSURL URLWithString:versionUrl] encoding:NSUTF8StringEncoding error:&errVersion];
    
	if(errVersion.code != 0) {
		// HANDLE ERROR HERE
		NSLog(@"Online Error: %@", [errVersion localizedDescription]);
	} else {
		NSLog(@"Online Version: %@", versionFile);
		
		if(databaseVersion < [versionFile doubleValue]){
			// New database available
			// Prompt user to download new version
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dictionary Update Ready"
                                                                message:@"There is a new version of the dictionary available for download.  Would you like to update now?"
                                                               delegate:self
                                                      cancelButtonTitle:@"No"
                                                      otherButtonTitles:@"Yes",nil];
                [alert show];
                [alert release];
            });
		} else {
			NSLog(@"Up to date");
		}
	}
    
    dispatch_async(dispatch_get_main_queue(), ^{
        app.networkActivityIndicatorVisible = NO; // to stop it, set this to NO
    });
    
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
	loadingView = [LoadingView loadingViewInView:[self window]];
	[self performSelectorInBackground:@selector(updateDatabase:) withObject:nil];
    
}

- (void)updateFinished:(id)sender
{
	[loadingView removeView];
	[self launchApp:self];
}

- (void)updateDatabase:(id)sender {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	// Download new version
	UIApplication* app = [UIApplication sharedApplication];
	app.networkActivityIndicatorVisible = YES; // to stop it, set this to NO
	
	NSString *databaseUrl = [[NSString stringWithFormat:@"https://files.learnnavi.org/mobile/database.sqlite"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSData *newDatabase = [NSData dataWithContentsOfURL:[NSURL URLWithString:databaseUrl]];
	
	if(newDatabase == nil){
		NSLog(@"Error downloading database");
		
	} else {
		
		NSString *databaseName = @"database.sqlite";
		
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		NSString *databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
		
		//Store database version before update.
		NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
		[prefs setObject:[prefs stringForKey:@"database_version"] forKey:@"database_pre-update_version"];
		
		//Delete current database
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		[fileManager removeItemAtPath:databasePath error:nil];
		[fileManager createFileAtPath:databasePath contents:newDatabase attributes:nil];
		
		[fileManager release];
		[self registerDatabaseInfo:databasePath];
		app.networkActivityIndicatorVisible = NO;
		
		
		// Show success message
		dispatch_async(dispatch_get_main_queue(), ^{
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dictionary Updated" message:@"The dictionary has been successfully updated."
													   delegate:self cancelButtonTitle:@"Done" otherButtonTitles:nil];
		[alert show];
		[alert release];
        });
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
	const char *sqlStatement = "select MAX(version) from version";
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
	NSString *dictionaryDateString;
	NSString *dateString;
	
	const char *sqlStatement = "select version,dictionary_date,date from version";
	sqlite3_stmt *compiledStatement;
	if(sqlite3_prepare_v2(dBase, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
		// Loop through the results and add them to the feeds array
		while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
			// Read the data from the result row
			versionString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			dictionaryDateString = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
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
	 setObject:dictionaryDateString forKey:@"dictionary_version"];
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
	NSString *dictionary_preupdate_version = [prefs stringForKey:@"database_pre-update_version"];
	if (dictionary_preupdate_version == nil) {
		dictionary_preupdate_version = @"0";
		[prefs setObject:@"0" forKey:@"database_pre-update_version"];
	}
	return [NSString stringWithFormat:@"Version %@ (%@-%@-%@)",[self bundleVersionNumber], [self bundleShortVersionString], dictionary_version, dictionary_preupdate_version];
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[window release];
	[super dealloc];
}


@end


