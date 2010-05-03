//
//  DictionaryTableViewController.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "DictionaryEntry.h"

@interface DictionaryTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSMutableArray *dictionaryContent;
	NSMutableArray *dictionaryContentIndex;
	NSMutableDictionary *indexCounts;
	NSMutableArray *filteredDictionaryContent;
	NSString *savedSearchTerm;
	NSInteger savedScopeButtonIndex;
	BOOL searchWasActive;
	UIViewController *viewController;
	UISegmentedControl *segmentedControl;
	NSMutableArray *listOfItems;
	BOOL currentMode;	//YES: Na'vi to English, NO: English to Na'vi
	BOOL cellSizeChanged;
	NSString *query;
	NSString *queryIndex;
	NSString *databaseName;
	NSString *databasePath;
	sqlite3 *database;
}

@property (nonatomic, retain) NSMutableArray *dictionaryContent, *filteredDictionaryContent;
@property (nonatomic, retain) NSMutableArray *dictionaryContentIndex;
@property (nonatomic, retain) NSMutableDictionary *indexCounts;
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) NSString *query, *queryIndex, *databasePath;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic) BOOL currentMode;

- (void) loadData;

- (void) addViewController:(UIViewController *)controller;
- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;

- (IBAction) swapDictionaryMode:(id)sender;

- (IBAction) filterDictionary:(id)sender;

-(void) readEntriesFromDatabase;

- (DictionaryEntry *) readEntryFromDatabase:(NSString *)alpha row:(int)row;

@end
