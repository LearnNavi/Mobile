//
//  Learn_Navi_iPhone_AppAppDelegate.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/8/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

@interface Learn_Navi_iPhone_AppAppDelegate : NSObject <UIApplicationDelegate> {
    
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
    UINavigationController *navigationController;
	UIView *homeView;
	UILabel *betaText;
	
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIView *homeView;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet UILabel *betaText;

- (NSString *)applicationDocumentsDirectory;
- (NSString *)versionString;
- (NSString *)bundleShortVersionString;
- (NSString *)bundleVersionNumber;

@end

