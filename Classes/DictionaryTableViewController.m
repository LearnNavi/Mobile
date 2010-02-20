//
//  DictionaryTableViewController.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import "DictionaryEntry.h"
#import "DictionaryTableViewController.h"
//#import "DictionarySection.h"
#import "DictionaryEntryViewController.h"
#import "UIViewAdditions.h"

@implementation DictionaryTableViewController


@synthesize dictionaryContent, dictionaryActiveContent, dictionaryActiveContentIndex, filteredDictionaryContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive, viewController, segmentedControl, currentMode, dictionaryTranslatedContent;

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/

- (void) addViewController:(UIViewController *)controller {
	self.viewController = controller;
	
}


- (void)viewDidLoad {
    
	//listOfItems = [[NSMutableArray alloc] init];
	[self loadData];
	[super viewDidLoad];
	currentMode = YES;
	
	//self.title = @"Products";
	
	
	// create a filtered list that will contain products for the search results table.
	self.filteredDictionaryContent = [NSMutableArray arrayWithCapacity:10];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	
	[self.tableView reloadData];
	self.tableView.scrollEnabled = YES;
	self.title = @"Na'vi > 'ìnglìsì";
	
	
	
	//defaultTintColor = [segmentedControl.tintColor retain];    // keep track of this for later
	
	UIBarButtonItem *flexibleSpaceButtonItem = [[UIBarButtonItem alloc]
												initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
												target:nil action:nil];
	
	UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
	[segmentedControl release];
	
	//self.navigationItem.rightBarButtonItem = segmentBarItem;
	self.toolbarItems = [NSArray arrayWithObjects:
                         flexibleSpaceButtonItem,
						 segmentBarItem,
						 flexibleSpaceButtonItem,
                         nil];
	[segmentBarItem release];
	[flexibleSpaceButtonItem release];
	//self.tableView.contentOffset = CGPointMake(0, self.searchDisplayController.searchBar.frame.size.height);
	
	UIButton* modalViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[modalViewButton addTarget:self action:@selector(swapDictionaryMode:) forControlEvents:UIControlEventTouchUpInside];
	[modalViewButton setImage:[UIImage imageNamed:@"Refresh.png"] forState:UIControlStateNormal];
	[modalViewButton setSize:[[UIImage imageNamed:@"Refresh.png"] size]];
	UIBarButtonItem *modalBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:modalViewButton];
	self.navigationItem.rightBarButtonItem = modalBarButtonItem;
	[modalBarButtonItem release];
	
	//self.navigationItem.rightBarButtonItem = 
	//[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Refresh.png"] style:UIBarButtonItemStylePlain target:nil action:nil];
}

- (IBAction) swapDictionaryMode:(id)sender {
	
	[UIView beginAnimations:@"Swap Dictionary" context:nil];
	[UIView setAnimationDuration:0.75];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:YES];

	if(currentMode) {
		[[self navigationItem] setTitle:@"English > Na'vi"];
				
		NSArray *vcs = [[self navigationController] viewControllers];
		[[[vcs objectAtIndex:0] navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Home"
																									   style: UIBarButtonItemStyleBordered
																									  target:nil
																									  action:nil]];
		[[self navigationController] setViewControllers:vcs];
		
	} else {
		[[self navigationItem] setTitle:@"Na'vi > 'ìnglìsì"];
		NSArray *vcs = [[self navigationController] viewControllers];
		[[[vcs objectAtIndex:0] navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Kelutral"
																									  style: UIBarButtonItemStyleBordered
																									 target:nil
																									 action:nil]];
		[[self navigationController] setViewControllers:vcs];
		
	}	
	[self loadData];
	
	[self.tableView reloadData];
	currentMode = !currentMode;
	[UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[[self navigationController] setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[[self navigationController] setToolbarHidden:NO animated:YES];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
	[[self navigationController] setToolbarHidden:NO animated:YES];
	
}



// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
	//(interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
	
	self.filteredDictionaryContent = nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	// The header for the section is the region name -- get this from the region at the section index.
		
	
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		return @"Search Results";
    }
	else
	{
		return [dictionaryActiveContentIndex objectAtIndex:section];
	}
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Number of sections is the number of regions.
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		return 1;
    }
	else
	{
		return [dictionaryActiveContentIndex count];
	}
}

#pragma mark Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	/*
	 If the requesting table view is the search display controller's table view, return the count of the filtered list, otherwise return the count of the main list.
	 */
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{

		return [self.filteredDictionaryContent count];
    }
	else
	{
        // Number of rows is the number of time zones in the region for the specified section.
		//DictionarySection *dictSection = [dictionaryActiveContent objectAtIndex:section];
		//return [dictSection.entries count];
		
		//---get the letter in each section; e.g., A, B, C, etc.---
		NSString *alphabet = [dictionaryActiveContentIndex objectAtIndex:section];
		
		//---get all states beginning with the letter---
		NSPredicate *predicate = 
        [NSPredicate predicateWithFormat:@"SELF.entryName beginswith[c] %@", alphabet];
		NSArray *entries = [dictionaryActiveContent filteredArrayUsingPredicate:predicate];
		
		//---return the number of states beginning with the letter---
		return [entries count];    		
		
    }
	
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
	
	/*
	 If the requesting table view is the search display controller's table view, configure the cell using the filtered content, otherwise use the main list.
	 */
	DictionaryEntry *entry = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		entry = [self.filteredDictionaryContent objectAtIndex:indexPath.row];
    }
	else
	{
        
		// Get the section index, and so the region for that section.
		//DictionarySection *dictSection = [dictionaryActiveContent objectAtIndex:indexPath.section];
		//entry = [dictSection.entries objectAtIndex:indexPath.row];
		
		
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] 
					 initWithStyle:UITableViewCellStyleDefault 
					 reuseIdentifier:CellIdentifier] autorelease];
		}
		
		//---get the letter in the current section---
		NSString *alphabet = [dictionaryActiveContentIndex objectAtIndex:[indexPath section]];
		
		//---get all states beginning with the letter---
		NSPredicate *predicate = 
        [NSPredicate predicateWithFormat:@"SELF.entryName beginswith[c] %@", alphabet];
		NSArray *entries = [dictionaryActiveContent filteredArrayUsingPredicate:predicate];
		
		if ([entries count]>0) {
			//---extract the relevant state from the states object---
			entry = [entries objectAtIndex:indexPath.row];
		}
		
		
    }
	
	cell.textLabel.text = entry.entryName;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DictionaryEntryViewController *detailsViewController = [[DictionaryEntryViewController alloc] initWithNibName:@"DictionaryEntryViewController" bundle:[NSBundle mainBundle]];

    
	/*
	 If the requesting table view is the search display controller's table view, configure the next view controller using the filtered content, otherwise use the main list.
	 */
	DictionaryEntry *entry = nil;
	if (tableView == self.searchDisplayController.searchResultsTableView)
	{
        entry = [self.filteredDictionaryContent objectAtIndex:indexPath.row];
    }
	else
	{
		//DictionarySection *dictSection = ;
		//entry = [dictSection.entries objectAtIndex:indexPath.row];
		
		//---get the letter in the current section---
		NSString *alphabet = [dictionaryActiveContentIndex objectAtIndex:[indexPath section]];
		
		//---get all states beginning with the letter---
		NSPredicate *predicate = 
        [NSPredicate predicateWithFormat:@"SELF.entryName beginswith[c] %@", alphabet];
		NSArray *entries = [dictionaryActiveContent filteredArrayUsingPredicate:predicate];
		
		if ([entries count]>0) {
			//---extract the relevant state from the states object---
			entry = [entries objectAtIndex:indexPath.row];
		}
		
    }
	//detailsViewController.title = entry.entryName;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//[(DictionaryViewController *)[self viewController] dictionaryEntrySelected:entry];
	self.navigationItem.backBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Dictionary"
									 style: UIBarButtonItemStyleBordered
									target:nil
									action:nil];
	[detailsViewController setEntry:entry];
	[[self navigationController] pushViewController:detailsViewController animated:YES];
    [detailsViewController release];
}




#pragma mark -
#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	/*
	 Update the filtered array based on the search text and scope.
	 */
	
	[self.filteredDictionaryContent removeAllObjects]; // First clear the filtered array.
	
	/*
	 Search the main list for products whose type matches the scope (if selected) and whose name matches searchText; add items that match to the filtered array.
	 */
	
	
	for (DictionaryEntry *entry in dictionaryActiveContent) {
		
		//NSComparisonResult result = [entry.entryName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
		//if (result == NSOrderedSame)
		if( [entry.entryName rangeOfString:searchText options:NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch].location != NSNotFound )
		{
			[self.filteredDictionaryContent addObject:entry];
		}
		
	}
	
}

//---set the index for the table---
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (tableView == self.searchDisplayController.searchResultsTableView)
	{
		return nil;
	} else {
		return dictionaryActiveContentIndex;
	}
}


#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (void)loadData {
	
	//Need to load data in from a file
			
			//[navigationController release];
	if(!dictionaryTranslatedContent){
		[self loadEnglishData];
	}
	
	if(!dictionaryContent){
		[self loadNaviData];
	}

	if(currentMode){
		//English Mode
		dictionaryActiveContent = dictionaryTranslatedContent;
		dictionaryActiveContentIndex = dictionaryTranslatedContentIndex;
	} else {
		//Na'vi Mode
		dictionaryActiveContent = dictionaryContent;
		dictionaryActiveContentIndex = dictionaryContentIndex;
	}
	//[[self tableView] reloadData];
}

- (void)loadEnglishData {
	//NSURL * url = [NSURL fileURLWithPath:@"NaviDictionary.tsv"];
	
	NSLog(@"Loading English");
	NSString *path = [[NSBundle mainBundle] pathForResource:@"NaviEnglish" ofType:@"tsv"];
	
	// Do something with the filename.
	NSError *error;
	NSString * fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error ];
	NSCharacterSet *newlineSet;
	NSCharacterSet *splitSet;
	NSScanner *scanner;
	scanner = [NSScanner scannerWithString:fileContents];
	[scanner setCharactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
	newlineSet = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
	splitSet = [NSCharacterSet characterSetWithCharactersInString:@"<|>"];
	NSMutableArray *entries = [NSMutableArray arrayWithCapacity:150];
	//DictionarySection *section = [DictionarySection sectionWithHeader:@"A" andEntries:[NSMutableArray arrayWithCapacity:20]];
	while ( ![scanner isAtEnd] ) {
		
		NSString *line = nil;
		NSScanner *lineScanner = nil;
		NSString *term = nil;
		NSString *partOfSpeech = nil;
		NSString *definition = nil;
		//NSString *thisSection;
		if ( ![scanner scanUpToCharactersFromSet:newlineSet intoString:&line] ) {
			//line = @"";
		}
		[scanner scanString:@"\n" intoString:NULL];
		lineScanner = [NSScanner scannerWithString:line]; // Create scanner for scanning line content
		[lineScanner setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		// Now scan symbol and coords, if they exist
		//record = 
		[lineScanner scanUpToCharactersFromSet:splitSet intoString:&definition]; 
		[lineScanner scanString:@"<|>" intoString:NULL]; 
		[lineScanner scanUpToCharactersFromSet:splitSet intoString:&partOfSpeech]; 
		[lineScanner scanString:@"<|>" intoString:NULL]; 
		[lineScanner scanUpToCharactersFromSet:splitSet intoString:&term]; 
		//NSLog(@"%@ ||| %@ ||| %@", term, partOfSpeech, definition);
		//thisSection = [term substringWithRange:NSMakeRange(0, 1)];
		//if([thisSection compare:@"*"] == 0){
		//	//Pesky *
		//	thisSection = [term substringWithRange:NSMakeRange(1, 1)];
		//}
		//if( [[thisSection uppercaseString] compare:[section sectionHeader]] != 0){
			//create new section
			//[sections addObject:section];
			//[entries release];
			//entries = ;
			//[section release];
			//section = [DictionarySection sectionWithHeader:[thisSection uppercaseString] andEntries:[NSMutableArray arrayWithCapacity:20]];
		//}
		[entries addObject:[DictionaryEntry entryWithName:term type:partOfSpeech andDefinition:definition]];
	}
	//[sections addObject:section];
	[self setDictionaryTranslatedContent:entries];
	
	dictionaryTranslatedContentIndex = [[NSMutableArray alloc] init];
	
	for(int i=0; i <[dictionaryTranslatedContent count]; i++){
		
		NSString *uniChar = [[[dictionaryTranslatedContent objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = [[[dictionaryTranslatedContent objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		
		if(![dictionaryTranslatedContentIndex containsObject:[uniChar uppercaseString]]){
			[dictionaryTranslatedContentIndex addObject:[uniChar uppercaseString]];
		}
		
	}


	
}

- (void)loadNaviData {
	//NSURL * url = [NSURL fileURLWithPath:@"NaviDictionary.tsv"];
	
	NSLog(@"Loading Na'vi");
	NSString *path = [[NSBundle mainBundle] pathForResource:@"NaviDictionary" ofType:@"tsv"];
	
	// Do something with the filename.
	NSError *error;
	NSString * fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error ];
	NSCharacterSet *newlineSet;
	NSCharacterSet *splitSet;
	NSScanner *scanner;
	scanner = [NSScanner scannerWithString:fileContents];
	[scanner setCharactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
	newlineSet = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
	splitSet = [NSCharacterSet characterSetWithCharactersInString:@"<|>"];
	//NSMutableArray *sections = [NSMutableArray arrayWithCapacity:30];
	NSMutableArray *entries = [NSMutableArray arrayWithCapacity:150];
	//DictionarySection *section = [DictionarySection sectionWithHeader:@"'" andEntries:[NSMutableArray arrayWithCapacity:20]];
	while ( ![scanner isAtEnd] ) {

		NSString *line = nil;
		NSScanner *lineScanner = nil;
		NSString *term = nil;
		NSString *partOfSpeech = nil;
		NSString *definition = nil;
		//NSString *thisSection;

		if ( ![scanner scanUpToCharactersFromSet:newlineSet intoString:&line] ) {
			//line = @"";
		}
		[scanner scanString:@"\n" intoString:NULL];
		lineScanner = [NSScanner scannerWithString:line]; // Create scanner for scanning line content
		[lineScanner setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		
		// Now scan symbol and coords, if they exist
		//record = 
		[lineScanner scanUpToCharactersFromSet:splitSet intoString:&term]; 
		[lineScanner scanString:@"<|>" intoString:NULL]; 
		[lineScanner scanUpToCharactersFromSet:splitSet intoString:&partOfSpeech]; 
		[lineScanner scanString:@"<|>" intoString:NULL]; 
		[lineScanner scanUpToCharactersFromSet:splitSet intoString:&definition]; 
		//NSLog(@"%@ ||| %@ ||| %@", term, partOfSpeech, definition);
		//thisSection = [term substringWithRange:NSMakeRange(0, 1)];
		//if([thisSection compare:@"*"] == 0){
			//Pesky *
		//	thisSection = [term substringWithRange:NSMakeRange(1, 1)];
		//}
		
		//if( [[thisSection uppercaseString] compare:[section sectionHeader]] != 0){
		//	//create new section
		//	[entries addObject:section];
			//[entries release];
			//entries = ;
			//[section release];
		//	section = [DictionarySection sectionWithHeader:[thisSection uppercaseString] andEntries:[NSMutableArray arrayWithCapacity:20]];
		//}
		[entries addObject:[DictionaryEntry entryWithName:term type:partOfSpeech andDefinition:definition]];
	}
	//[entries addObject:section];
	
	[self setDictionaryContent:entries];
	
	dictionaryContentIndex = [[NSMutableArray alloc] init];
	
	for(int i=0; i <[dictionaryContent count]; i++){
		NSString *uniChar = [[[dictionaryContent objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = [[[dictionaryContent objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		
		if(![dictionaryContentIndex containsObject:[uniChar uppercaseString]]){
			[dictionaryContentIndex addObject:[uniChar uppercaseString]];
		}
		
	}
	
	
}


- (void)dealloc {
	[dictionaryContent dealloc];
	[filteredDictionaryContent dealloc];
	[dictionaryTranslatedContent dealloc];
	 
    [super dealloc];
}


@end

