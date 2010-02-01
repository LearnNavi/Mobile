//
//  DictionaryTableViewController.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DictionaryTableViewController : UITableViewController <UISearchDisplayDelegate, UISearchBarDelegate> {
	NSArray *dictionaryContent;
	NSArray *dictionaryTranslatedContent;
	NSMutableArray *dictionaryActiveContent;
	NSMutableArray *filteredDictionaryContent;
	NSString *savedSearchTerm;
	NSInteger savedScopeButtonIndex;
	BOOL searchWasActive;
	UIViewController *viewController;
	UISegmentedControl *segmentedControl;
	NSMutableArray *listOfItems;
	BOOL currentMode;	//YES: Na'vi to English, NO: English to Na'vi
}

@property (nonatomic, retain) NSArray *dictionaryContent, *dictionaryTranslatedContent;
@property (nonatomic, retain) NSMutableArray *filteredDictionaryContent, *dictionaryActiveContent;
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic) BOOL currentMode;

- (void) loadData;

- (void) addViewController:(UIViewController *)controller;

- (IBAction) swapDictionaryMode:(id)sender;


@end
