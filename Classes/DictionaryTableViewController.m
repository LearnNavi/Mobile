//
//  DictionaryTableViewController.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import "DictionaryEntry.h"
#import "DictionaryTableViewController.h"
#import "DictionarySection.h"
#import "DictionaryEntryViewController.h"
#import "UIViewAdditions.h"

@implementation DictionaryTableViewController


@synthesize dictionaryContent, dictionaryActiveContent, filteredDictionaryContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive, viewController, segmentedControl, currentMode, dictionaryTranslatedContent;

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
	
	self.title = @"Products";
	
	
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
	/*NSInteger nSections = [self.tableView numberOfSections];
	for (int j=nSections-1; j>=0; j--) {
		NSInteger nRows = [self.tableView numberOfRowsInSection:j];
		for (int i=nRows-1; i>=0; i--) {
			

			DictionarySection *dictSection = [dictionaryActiveContent objectAtIndex:[NSIndexPath indexPathForRow:i inSection:j].section];
			NSMutableArray *temp = [NSMutableArray arrayWithArray:dictSection.entries];
			[temp removeObjectAtIndex:[NSIndexPath indexPathForRow:i inSection:j].row];
			
			dictSection.entries = temp;
			[[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:i inSection:j]] withRowAnimation:YES];
			//[indexPath addObject:[NSIndexPath indexPathForRow:i inSection:j]];
			//Do something with your indexPath. Maybe you want to get your cell,
			// like this:
			//UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
		}
		//[dictionaryActiveContent removeLastObject];
		//[[self tableView] deleteSections:[NSIndexSet indexSetWithIndex:j] withRowAnimation:YES];
	}
	[dictionaryActiveContent removeAllObjects];
	[self.tableView reloadData];
	 */
	if(currentMode) {
		//self.title = @"English > Na'vi";
		[[self navigationItem] setTitle:@"English > Na'vi"];
		/*[[[[self navigationController] topViewController] navigationItem] setBackBarButtonItem:
		[[UIBarButtonItem alloc] initWithTitle:@"Home"
										 style: UIBarButtonItemStyleBordered
										target:nil
										action:nil]];*/
		
		NSArray *vcs = [[self navigationController] viewControllers];
		[[[vcs objectAtIndex:0] navigationItem] setBackBarButtonItem:[[UIBarButtonItem alloc] initWithTitle:@"Home"
																									   style: UIBarButtonItemStyleBordered
																									  target:nil
																									  action:nil]];
		
		
		[[self navigationController] setViewControllers:vcs];
		//[[self navigationController] pushViewController:self animated:YES];
	} else {
		//self.title = @"Na'vi > 'ìnglìsì";
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
		DictionarySection *dictSection = [dictionaryActiveContent objectAtIndex:section];
		return [dictSection sectionHeader];
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
		return [dictionaryActiveContent count];
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
		DictionarySection *dictSection = [dictionaryActiveContent objectAtIndex:section];
		return [dictSection.entries count];
		
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
		DictionarySection *dictSection = [dictionaryActiveContent objectAtIndex:indexPath.section];
		entry = [dictSection.entries objectAtIndex:indexPath.row];
		
		
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
		DictionarySection *dictSection = [dictionaryActiveContent objectAtIndex:indexPath.section];
		entry = [dictSection.entries objectAtIndex:indexPath.row];
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
	
	
	for (DictionarySection *sect in dictionaryActiveContent)
	{
		
		for (DictionaryEntry *entry in sect.entries) {
			
			//NSComparisonResult result = [entry.entryName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
			//if (result == NSOrderedSame)
			if( [entry.entryName rangeOfString:searchText].location != NSNotFound )
			{
				[self.filteredDictionaryContent addObject:entry];
			}
			
		}
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
	
	
	
	if(currentMode){
		//English Mode
		[self loadEnglishData];
		
		/*
		
		DictionarySection *tsection = [DictionarySection sectionWithHeader:@"B" andEntries:[NSArray arrayWithObjects:[DictionaryEntry entryWithName:@"banshee" type:@"Noun" andDefinition:@"ikran"],
																							[DictionaryEntry entryWithName:@"blue flower" type:@"Noun" andDefinition:@"seze"], nil]];
		DictionarySection *tsection1 = [DictionarySection sectionWithHeader:@"H" andEntries:[NSArray arrayWithObjects:[DictionaryEntry entryWithName:@"hunter" type:@"Noun" andDefinition:@"taronyu"], nil]];
		DictionarySection *tsection2 = [DictionarySection sectionWithHeader:@"T" andEntries:[NSArray arrayWithObjects:[DictionaryEntry entryWithName:@"thank you" type:@"Noun" andDefinition:@"irayo"], nil]];
		DictionarySection *tsection3 = [DictionarySection sectionWithHeader:@"W" andEntries:[NSArray arrayWithObjects:[DictionaryEntry entryWithName:@"warrior" type:@"Noun" andDefinition:@"tsamsiyu"], nil]];
		
		[self setDictionaryTranslatedContent:[NSArray arrayWithObjects:tsection, tsection1, tsection2, tsection3, nil]];
		
		[self setDictionaryActiveContent:[dictionaryTranslatedContent mutableCopy]];
		 */
	} else {
		//Na'vi Mode
		
		[self loadNaviData];
		/*
		DictionarySection *section = [DictionarySection sectionWithHeader:@"I" andEntries:[NSArray arrayWithObjects:[DictionaryEntry entryWithName:@"ikran" type:@"Noun" andDefinition:@"banshee"],
																						   [DictionaryEntry entryWithName:@"irayo" type:@"Noun" andDefinition:@"thank you"], nil]];
		DictionarySection *section1 = [DictionarySection sectionWithHeader:@"S" andEntries:[NSArray arrayWithObjects:[DictionaryEntry entryWithName:@"seze" type:@"Noun" andDefinition:@"blue flower"], nil]];
		DictionarySection *section2 = [DictionarySection sectionWithHeader:@"T" andEntries:[NSArray arrayWithObjects:[DictionaryEntry entryWithName:@"taronyu" type:@"Noun" andDefinition:@"hunter"],
																							[DictionaryEntry entryWithName:@"tsamsiyu" type:@"Noun" andDefinition:@"warrior"], nil]];
		[self setDictionaryContent:[NSArray arrayWithObjects:section, section1, section2, nil]];
		
		[self setDictionaryActiveContent:[dictionaryContent mutableCopy]];
		 */
	}
	//[[self tableView] reloadData];
}

- (void)loadEnglishData {
	//NSURL * url = [NSURL fileURLWithPath:@"NaviDictionary.tsv"];
	if(!dictionaryTranslatedContent){
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
		NSMutableArray *sections = [NSMutableArray arrayWithCapacity:30];
		DictionarySection *section = [DictionarySection sectionWithHeader:@"A" andEntries:[NSMutableArray arrayWithCapacity:20]];
		while ( ![scanner isAtEnd] ) {
			
			NSString *line = nil;
			NSScanner *lineScanner = nil;
			NSString *term = nil;
			NSString *partOfSpeech = nil;
			NSString *definition = nil;
			NSString *thisSection;
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
			thisSection = [term substringWithRange:NSMakeRange(0, 1)];
			if([thisSection compare:@"*"] == 0){
				//Pesky *
				thisSection = [term substringWithRange:NSMakeRange(1, 1)];
			}
			if( [[thisSection uppercaseString] compare:[section sectionHeader]] != 0){
				//create new section
				[sections addObject:section];
				//[entries release];
				//entries = ;
				//[section release];
				section = [DictionarySection sectionWithHeader:[thisSection uppercaseString] andEntries:[NSMutableArray arrayWithCapacity:20]];
			}
			[section addEntry:[DictionaryEntry entryWithName:term type:partOfSpeech andDefinition:definition]];
		}
		[sections addObject:section];
		[self setDictionaryTranslatedContent:sections];
	}
	[self setDictionaryActiveContent:[NSArray arrayWithArray:dictionaryTranslatedContent]];
}

- (void)loadNaviData {
	//NSURL * url = [NSURL fileURLWithPath:@"NaviDictionary.tsv"];
	if(!dictionaryContent){
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
		NSMutableArray *sections = [NSMutableArray arrayWithCapacity:30];
		DictionarySection *section = [DictionarySection sectionWithHeader:@"'" andEntries:[NSMutableArray arrayWithCapacity:20]];
		while ( ![scanner isAtEnd] ) {

			NSString *line = nil;
			NSScanner *lineScanner = nil;
			NSString *term = nil;
			NSString *partOfSpeech = nil;
			NSString *definition = nil;
			NSString *thisSection;

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
			thisSection = [term substringWithRange:NSMakeRange(0, 1)];
			if([thisSection compare:@"*"] == 0){
				//Pesky *
				thisSection = [term substringWithRange:NSMakeRange(1, 1)];
			}
			
			if( [[thisSection uppercaseString] compare:[section sectionHeader]] != 0){
				//create new section
				[sections addObject:section];
				//[entries release];
				//entries = ;
				//[section release];
				section = [DictionarySection sectionWithHeader:[thisSection uppercaseString] andEntries:[NSMutableArray arrayWithCapacity:20]];
			}
			[section addEntry:[DictionaryEntry entryWithName:term type:partOfSpeech andDefinition:definition]];
		}
		[sections addObject:section];
		
		[self setDictionaryContent:sections];
	}
	[self setDictionaryActiveContent:[NSArray arrayWithArray:dictionaryContent]];
}


- (void)dealloc {
	[dictionaryContent dealloc];
	[filteredDictionaryContent dealloc];
	[dictionaryTranslatedContent dealloc];
	 
    [super dealloc];
}


@end

