//
//  DictionaryEntryViewController.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DictionaryEntryViewController : UIViewController {
	UISegmentedControl *segmentedControl;
}

@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)playAudioFile:(id)sender;

@end
