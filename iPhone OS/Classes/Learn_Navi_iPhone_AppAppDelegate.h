//
//  Learn_Navi_iPhone_AppAppDelegate.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/8/10.
//  Copyright LearnNa'vi.org Community. 2010. All rights reserved.
//

#import "AppViewController.h"
#import "LoadingView.h"

@interface Learn_Navi_iPhone_AppAppDelegate : NSObject <UIApplicationDelegate, UIAlertViewDelegate> {
    

	CGRect theRect;

    UIWindow *window;
    AppViewController *appViewController;
	LoadingView *loadingView;
}


@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) AppViewController *appViewController;


- (void)registerDefaultsFromSettingsBundle;
- (void) checkAndCreateDatabase;
- (double)getDatabaseVersion:(NSString *)aDatabase;
- (NSString *)versionString;
- (NSString *)bundleShortVersionString;
- (NSString *)bundleVersionNumber;
- (void)registerDatabaseInfo:(NSString *)aDatabase;
- (void)launchApp:(id)sender;
- (void)updateDatabase:(id)sender;
- (void)startUpdate:(id)sender;
- (void)checkDatabaseVersion:(id)sender;
- (void)updateFinished:(id)sender;

@end

