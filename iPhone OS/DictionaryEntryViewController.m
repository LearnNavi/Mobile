//
//  DictionaryEntryViewController.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/24/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import "DictionaryEntry.h"
#import "DictionaryEntryViewController.h"

@implementation DictionaryEntryViewController

@synthesize segmentedControl, entry, definition, term, fancyType, mode, ipa, infixes, infixHeader;


 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        
    }
    return self;
}

- (IBAction)playAudioFile:(id)sender {
	NSLog(@"Play File");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[[self navigationController] setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	//[[self navigationItem] setTitle:@"Entry"];
	//if(mode){
		[definition setText:[self.entry english_definition]];
		[term setText:[self.entry navi]];
		
	//} else {
		//[definition setText:[self.entry navi]];
		//[term setText:[self.entry english_definition]];
		
	//}
	
	
	[ipa setText:[self.entry ipa]];
	if([[self.entry infixes] compare:@""] != 0){
		//We have an entry that supports infixes
		
		
		[infixHeader setText:@"Infix Positions"];
		[infixes setText:[self.entry infixes]];
	} else {
		[infixes setText:@""];
		[infixHeader setText:@""];
	}

	
	[fancyType setText:[self.entry fancyType]];
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
	
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    
	[super viewDidLoad];
	
	self.title = [self.entry navi];
	

	/*UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc]
												initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
												target:nil action:nil];
	
	//UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Play" style:UIBarButtonItemStyleBordered target:self action:@selector(playAudioFile:)];
	//self.navigationItem.rightBarButtonItem = addButton;
	//[self.navigationItem.rightBarButtonItem ];
	//[addButton release];
	
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	//[segmentedControl release];
	
	//self.navigationItem.rightBarButtonItem = segmentBarItem;
	[self  setToolbarItems:[NSArray arrayWithObjects:
							flexibleSpaceButtonItem,
							segmentBarItem,
							nil] animated:YES];
	//self.toolbarItems ;
	 
	[segmentBarItem release];
	[flexibleSpaceButtonItem release];
	 */
	
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
