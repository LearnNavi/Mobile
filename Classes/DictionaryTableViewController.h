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
	NSMutableArray *dictionaryContentIndex;
	
	NSArray *dictionaryContentNouns;
	NSMutableArray *dictionaryContentNounsIndex;
	
	NSArray *dictionaryContentVerbs;
	NSMutableArray *dictionaryContentVerbsIndex;
	
	NSArray *dictionaryContentAdjectives;
	NSMutableArray *dictionaryContentAdjectivesIndex;
	
	NSArray *dictionaryContentAdverbs;
	NSMutableArray *dictionaryContentAdverbsIndex;
	
	NSArray *dictionaryContentProNouns;
	NSMutableArray *dictionaryContentProNounsIndex;
	
	NSArray *dictionaryTranslatedContent;
	NSMutableArray *dictionaryTranslatedContentIndex;
	
	NSArray *dictionaryTranslatedContentNouns;
	NSMutableArray *dictionaryTranslatedContentNounsIndex;
	
	NSArray *dictionaryTranslatedContentVerbs;
	NSMutableArray *dictionaryTranslatedContentVerbsIndex;
	
	NSArray *dictionaryTranslatedContentAdjectives;
	NSMutableArray *dictionaryTranslatedContentAdjectivesIndex;
	
	NSArray *dictionaryTranslatedContentAdverbs;
	NSMutableArray *dictionaryTranslatedContentAdverbsIndex;
	
	NSArray *dictionaryTranslatedContentProNouns;
	NSMutableArray *dictionaryTranslatedContentProNounsIndex;
	
	NSArray *dictionaryActiveContent;
	NSMutableArray *dictionaryActiveContentIndex;
	
	NSMutableArray *filteredDictionaryContent;
	NSString *savedSearchTerm;
	NSInteger savedScopeButtonIndex;
	BOOL searchWasActive;
	UIViewController *viewController;
	UISegmentedControl *segmentedControl;
	NSMutableArray *listOfItems;
	BOOL currentMode;	//YES: Na'vi to English, NO: English to Na'vi
	BOOL cellSizeChanged;
}

@property (nonatomic, retain) NSArray *dictionaryContent, *dictionaryTranslatedContent, *dictionaryActiveContent, *dictionaryTranslatedContentAdverbs;
@property (nonatomic, retain) NSArray *dictionaryTranslatedContentNouns, *dictionaryTranslatedContentVerbs, *dictionaryContentAdverbs;
@property (nonatomic, retain) NSArray *dictionaryTranslatedContentProNouns, *dictionaryTranslatedContentAdjectives;
@property (nonatomic, retain) NSArray *dictionaryContentNouns, *dictionaryContentProNouns, *dictionaryContentAdjectives, *dictionaryContentVerbs;
@property (nonatomic, retain) NSMutableArray *filteredDictionaryContent, *dictionaryActiveContentIndex;
@property (nonatomic, retain) UIViewController *viewController;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic) BOOL currentMode;

- (void) loadData;
- (void)loadEnglishData;
- (void)loadNaviData;

- (void) addViewController:(UIViewController *)controller;
- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier;

- (IBAction) swapDictionaryMode:(id)sender;

- (IBAction) filterDictionary:(id)sender;


@end
