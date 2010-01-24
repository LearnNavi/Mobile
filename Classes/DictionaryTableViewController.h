//
//  DictionaryTableViewController.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DictionaryTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSArray *dictionaryContent;
	NSMutableArray *filteredDictionaryContent;
	NSString *savedSearchTerm;
	NSInteger savedScopeButtonIndex;
	BOOL searchWasActive;
	UIViewController *viewController;
	UISegmentedControl *segmentedControl;
	NSMutableArray *listOfItems;
}

@property (nonatomic, retain) NSArray *dictionaryContent;
@property (nonatomic, retain) NSMutableArray *filteredDictionaryContent;
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;

- (void) loadData;

- (void) addViewController:(UIViewController *)controller;


@end
