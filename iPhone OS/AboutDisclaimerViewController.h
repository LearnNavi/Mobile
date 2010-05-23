//
//  AboutDisclaimerViewController.h
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 2/20/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AboutDisclaimerViewController : UIViewController {
	UITextView *contentText;
	UITextView *contentTextShadow;
	UIImageView *bg_image;
	BOOL type;
}

@property (nonatomic, retain) IBOutlet UITextView *contentText, *contentTextShadow;
@property (nonatomic, retain) IBOutlet UIImageView *bg_image;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil type:(BOOL)contentType;
- (IBAction)doneReading:(id)sender;
- (void)setupAbout;
- (void)setupDisclaimer;

@end
