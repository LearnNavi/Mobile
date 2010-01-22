//
//  DictionaryViewController.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/17/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictionaryTableViewController.h"
#import "DictionaryEntry.h"


@interface DictionaryViewController : UIViewController {
	UIView *tableView;
	DictionaryTableViewController *tableController;
}

@property (nonatomic, retain) IBOutlet UIView *tableView;
@property (nonatomic, retain) DictionaryTableViewController *tableController;

- (IBAction) goHome:(id)sender;

- (void) dictionaryEntrySelected:(DictionaryEntry *)entry;

@end
