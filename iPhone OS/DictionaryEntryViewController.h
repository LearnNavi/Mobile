//
//  DictionaryEntryViewController.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/24/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DictionaryEntryViewController : UIViewController {
	UISegmentedControl *segmentedControl;
	DictionaryEntry *entry;
	UILabel *fancyType;
	UILabel *term;
	UITextView *definition;
	UILabel *ipa;
	UILabel *infixes;
	UILabel *infixHeader;
	BOOL mode;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UILabel *fancyType, *term, *ipa;
@property (nonatomic, retain) IBOutlet UITextView *definition;
@property (nonatomic, retain) IBOutlet UILabel *infixes, *infixHeader;
@property (nonatomic, retain) DictionaryEntry *entry;
@property (nonatomic) BOOL mode;

- (IBAction)playAudioFile:(id)sender;

@end
