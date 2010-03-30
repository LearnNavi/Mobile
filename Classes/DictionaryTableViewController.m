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


@synthesize dictionaryContent, dictionaryActiveContent, dictionaryActiveContentIndex, filteredDictionaryContent; 
@synthesize savedSearchTerm, savedScopeButtonIndex, searchWasActive, viewController, segmentedControl, currentMode;
@synthesize dictionaryTranslatedContent, dictionaryTranslatedContentNouns, dictionaryTranslatedContentVerbs, dictionaryTranslatedContentAdverbs;
@synthesize dictionaryTranslatedContentProNouns, dictionaryTranslatedContentAdjectives, dictionaryContentNouns;
@synthesize dictionaryContentProNouns, dictionaryContentAdjectives, dictionaryContentVerbs, dictionaryContentAdverbs;

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
	
	[super viewDidLoad];
	currentMode = YES;
	[self loadData];
	
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
	
	cellSizeChanged = NO;
	
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

- (IBAction) filterDictionary:(id)sender {
	
	cellSizeChanged = YES;
	
	
	if(currentMode){
		switch(segmentedControl.selectedSegmentIndex) {
			case 0:
				// All
				// Do nothing
				
				dictionaryActiveContent = dictionaryContent;
				dictionaryActiveContentIndex = dictionaryContentIndex;
				break;
			case 1:
				// Nouns
				dictionaryActiveContent = dictionaryContentNouns;
				dictionaryActiveContentIndex = dictionaryContentNounsIndex;
				break;
			case 2:
				// Pronouns
				dictionaryActiveContent = dictionaryContentProNouns;
				dictionaryActiveContentIndex = dictionaryContentProNounsIndex;
				break;
			case 3:
				// Verbs
				dictionaryActiveContent = dictionaryContentVerbs;
				dictionaryActiveContentIndex = dictionaryContentVerbsIndex;
				break;
			case 4:
				// Adjectives
				dictionaryActiveContent = dictionaryContentAdjectives;
				dictionaryActiveContentIndex = dictionaryContentAdjectivesIndex;
				break;
			case 5:
				// Adverbs
				dictionaryActiveContent = dictionaryContentAdverbs;
				dictionaryActiveContentIndex = dictionaryContentAdverbsIndex;
				break;
			default:
				break;
				
		}
	} else {
		switch(segmentedControl.selectedSegmentIndex) {
			case 0:
				// All
				// Do nothing
				
				dictionaryActiveContent = dictionaryTranslatedContent;
				dictionaryActiveContentIndex = dictionaryTranslatedContentIndex;
				break;
			case 1:
				// Nouns
				dictionaryActiveContent = dictionaryTranslatedContentNouns;
				dictionaryActiveContentIndex = dictionaryTranslatedContentNounsIndex;
				break;
			case 2:
				// Pronouns
				dictionaryActiveContent = dictionaryTranslatedContentProNouns;
				dictionaryActiveContentIndex = dictionaryTranslatedContentProNounsIndex;
				break;
			case 3:
				// Verbs
				dictionaryActiveContent = dictionaryTranslatedContentVerbs;
				dictionaryActiveContentIndex = dictionaryTranslatedContentVerbsIndex;
				break;
			case 4:
				// Adjectives
				dictionaryActiveContent = dictionaryTranslatedContentAdjectives;
				dictionaryActiveContentIndex = dictionaryTranslatedContentAdjectivesIndex;
				break;
			case 5:
				// Adverbs
				dictionaryActiveContent = dictionaryTranslatedContentAdverbs;
				dictionaryActiveContentIndex = dictionaryTranslatedContentAdverbsIndex;
				break;
			default:
				break;
				
		}
		
	}
	
	[self.tableView reloadData];
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
	
	
	currentMode = !currentMode;
	[self loadData];
	[self.tableView reloadData];

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


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
	//(interfaceOrientation == UIInterfaceOrientationPortrait);
}*/


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
		NSString *alphabet = [[dictionaryActiveContentIndex objectAtIndex:section] capitalizedString];
		
		NSPredicate *predicate;
		//---get all states beginning with the letter---
		if(([alphabet compare:@"Kx"] == 0) || ([alphabet compare:@"Px"] == 0) || ([alphabet compare:@"Tx"] == 0) || ([alphabet compare:@"Ng"] == 0)){
			//Dual letter character header
			
			predicate = [NSPredicate predicateWithFormat:@"SELF.entryName beginswith[c] %@", alphabet];
		} else if(([alphabet compare:@"K"] == 0) || ([alphabet compare:@"P"] == 0) || ([alphabet compare:@"T"] == 0)){
			
			predicate = [NSPredicate predicateWithFormat:@"(SELF.entryName beginswith[c] %@) AND NOT (SELF.entryName beginswith[c] %@)", alphabet, [NSString stringWithFormat:@"%@x",alphabet]];
		} else if([alphabet compare:@"N"] == 0){
			
			predicate = [NSPredicate predicateWithFormat:@"(SELF.entryName beginswith[c] %@) AND NOT (SELF.entryName beginswith[c] %@)", alphabet, [NSString stringWithFormat:@"%@g",alphabet]];
		} else {
			
			predicate = [NSPredicate predicateWithFormat:@"SELF.entryName beginswith[c] %@", alphabet];
		}
		
		NSArray *entries = [dictionaryActiveContent filteredArrayUsingPredicate:predicate];
		
		//---return the number of states beginning with the letter---
		return [entries count];    		
		
    }
	
	
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *kCellID = @"cellID";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if(cellSizeChanged){
		
		while(cell != nil){
			cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
		}
		cellSizeChanged = NO;
	}
	
	
	if (cell == nil)
	{	
		
		//cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID] autorelease];
		cell = [self getCellContentView:kCellID];
		//cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
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
		
		/*
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = 
        [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] 
					 initWithStyle:UITableViewCellStyleDefault 
					 reuseIdentifier:CellIdentifier] autorelease];
		}
		*/
		//---get the letter in the current section---
		NSString *alphabet = [dictionaryActiveContentIndex objectAtIndex:[indexPath section]];
		
		NSPredicate *predicate;
		//---get all states beginning with the letter---
		if(([alphabet compare:@"Kx"] == 0) || ([alphabet compare:@"Px"] == 0) || ([alphabet compare:@"Tx"] == 0) || ([alphabet compare:@"Ng"] == 0)){
			//Dual letter character header
			
			predicate = [NSPredicate predicateWithFormat:@"SELF.entryName beginswith[c] %@", alphabet];
		} else if(([alphabet compare:@"K"] == 0) || ([alphabet compare:@"P"] == 0) || ([alphabet compare:@"T"] == 0)){
			
			predicate = [NSPredicate predicateWithFormat:@"(SELF.entryName beginswith[c] %@) AND NOT (SELF.entryName beginswith[c] %@)", alphabet, [NSString stringWithFormat:@"%@x",alphabet]];
		} else if([alphabet compare:@"N"] == 0){
			
			predicate = [NSPredicate predicateWithFormat:@"(SELF.entryName beginswith[c] %@) AND NOT (SELF.entryName beginswith[c] %@)", alphabet, [NSString stringWithFormat:@"%@g",alphabet]];
		} else {
			
			predicate = [NSPredicate predicateWithFormat:@"SELF.entryName beginswith[c] %@", alphabet];
		}
		
		NSArray *entries = [dictionaryActiveContent filteredArrayUsingPredicate:predicate];
		
		if ([entries count]>0) {
			//---extract the relevant state from the states object---
			entry = [entries objectAtIndex:indexPath.row];
		}
		
		
    }
	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
	
	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];

			
	lblTemp1.text = entry.entryName;
	lblTemp2.text = entry.definition;
	
	
	return cell;
}

- (UITableViewCell *) getCellContentView:(NSString *)cellIdentifier {
	
	UITableViewCell *cell;
	
	CGRect CellFrame = CGRectMake(0, 0, 300, 60);
	CGRect Label1Frame = CGRectMake(10, 5, 290, 25);
	CGRect Label2Frame = CGRectMake(10, 28, 290, 25);
	UILabel *lblTemp;
	
	cell = [[[UITableViewCell alloc] initWithFrame:CellFrame reuseIdentifier:cellIdentifier] autorelease];
	
	//Initialize Label with tag 1.
	lblTemp = [[UILabel alloc] initWithFrame:Label1Frame];
	lblTemp.tag = 1;
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	//Initialize Label with tag 2.
	lblTemp = [[UILabel alloc] initWithFrame:Label2Frame];
	lblTemp.tag = 2;
	lblTemp.font = [UIFont boldSystemFontOfSize:12];
	lblTemp.textColor = [UIColor lightGrayColor];
	[cell.contentView addSubview:lblTemp];
	[lblTemp release];
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 60;
	
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
		NSPredicate *predicate;
		//---get all states beginning with the letter---
		if(([alphabet compare:@"Kx"] == 0) || ([alphabet compare:@"Px"] == 0) || ([alphabet compare:@"Tx"] == 0) || ([alphabet compare:@"Ng"] == 0)){
			//Dual letter character header
			
			predicate = [NSPredicate predicateWithFormat:@"SELF.entryName beginswith[c] %@", alphabet];
		} else if(([alphabet compare:@"K"] == 0) || ([alphabet compare:@"P"] == 0) || ([alphabet compare:@"T"] == 0)){
			
			predicate = [NSPredicate predicateWithFormat:@"(SELF.entryName beginswith[c] %@) AND NOT (SELF.entryName beginswith[c] %@)", alphabet, [NSString stringWithFormat:@"%@x",alphabet]];
		} else if([alphabet compare:@"N"] == 0){
		
			predicate = [NSPredicate predicateWithFormat:@"(SELF.entryName beginswith[c] %@) AND NOT (SELF.entryName beginswith[c] %@)", alphabet, [NSString stringWithFormat:@"%@g",alphabet]];
		} else {
			
			predicate = [NSPredicate predicateWithFormat:@"SELF.entryName beginswith[c] %@", alphabet];
		}
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
	/*
	if(currentMode){
		//English Mode
		dictionaryActiveContent = dictionaryTranslatedContent;
		dictionaryActiveContentIndex = dictionaryTranslatedContentIndex;
	} else {
		//Na'vi Mode
		dictionaryActiveContent = dictionaryContent;
		dictionaryActiveContentIndex = dictionaryContentIndex;
	}*/
	
	[self filterDictionary:nil];
	//[[self tableView] reloadData];
}

- (void)loadEnglishData {
	//NSURL * url = [NSURL fileURLWithPath:@"NaviDictionary.tsv"];
	
	NSLog(@"Loading English");
	NSString *path = [[NSBundle mainBundle] pathForResource:@"NaviDictionary" ofType:@"csv"];
	
	// Do something with the filename.
	NSError *error;
	NSString * fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error ];
	NSCharacterSet *newlineSet;
	NSCharacterSet *splitSet;
	NSScanner *scanner;
	scanner = [NSScanner scannerWithString:fileContents];
	[scanner setCharactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
	newlineSet = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
	splitSet = [NSCharacterSet characterSetWithCharactersInString:@";"];
	NSMutableArray *entries = [NSMutableArray arrayWithCapacity:150];
	NSMutableArray *entriesN = [NSMutableArray arrayWithCapacity:150];
	NSMutableArray *entriesPN = [NSMutableArray arrayWithCapacity:150];
	NSMutableArray *entriesADJ = [NSMutableArray arrayWithCapacity:150];
	NSMutableArray *entriesV = [NSMutableArray arrayWithCapacity:150];
	NSMutableArray *entriesADV = [NSMutableArray arrayWithCapacity:150];
	
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
		[lineScanner scanString:@";" intoString:NULL]; 
		[lineScanner scanUpToCharactersFromSet:splitSet intoString:&term]; 
		[lineScanner scanString:@";" intoString:NULL]; 
		[lineScanner scanUpToCharactersFromSet:splitSet intoString:&partOfSpeech]; 
		//NSLog(@"%@ - %@", term, partOfSpeech);
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
		NSString *fancyType;
		if([partOfSpeech compare:@"pn."] == 0){
			fancyType = @"Pronoun";		
			
		} else if([partOfSpeech compare:@"n."] == 0){
			fancyType = @"Noun";			
			
		} else if([partOfSpeech compare:@"v."] == 0){
			fancyType = @"Verb";			
			
		} else if([partOfSpeech compare:@"adj."] == 0){
			fancyType = @"Adjective";			
			
		} else if([partOfSpeech compare:@"adv."] == 0){
			fancyType = @"Adverb";	
			
		} else if([partOfSpeech compare:@"part."] == 0){
			fancyType = @"Participle";
			
		} else if([partOfSpeech compare:@"part. for"] == 0){
			fancyType = @"Participle";
			
		} else if([partOfSpeech compare:@"prep."] == 0){
			fancyType = @"Preposition";	
			
		} else if([partOfSpeech compare:@"dem."] == 0){
			fancyType = @"Demonstrative";
			
		} else if([partOfSpeech compare:@"conj."] == 0){
			fancyType = @"Conjunction";
			
		} else if([partOfSpeech compare:@"adp."] == 0){
			fancyType = @"Adpositional Affix";
			
		} else if([partOfSpeech compare:@"inter."] == 0){
			fancyType = @"Interrogative";
			
		} else if([partOfSpeech compare:@"prop.b"] == 0){
			fancyType = @"Proper Noun";
			
		} else if([partOfSpeech compare:@"prop.n."] == 0){
			fancyType = @"Proper Noun";
			
		} else if([partOfSpeech compare:@"prop.n"] == 0){
			fancyType = @"Proper Noun";
			
		} else if([partOfSpeech compare:@"num."] == 0){
			fancyType = @"Number";
			
		} else if([partOfSpeech compare:@"n., intj."] == 0){
			fancyType = @"Noun, Interjection";
			
		} else if([partOfSpeech compare:@"intj."] == 0){
			fancyType = @"Interjection";
			
		} else if([partOfSpeech compare:@"adv., adj."] == 0){
			fancyType = @"Adverb, Adjective";
			
		} else if([partOfSpeech compare:@"phrase"] == 0){
			fancyType = @"Phrase";
			
		} else if([partOfSpeech compare:@"affix inter. marker"] == 0){
			fancyType = @"Interrogative Affix";
			
		} else if([partOfSpeech compare:@"n"] == 0){
			fancyType = @"Noun";
			
		} else if([partOfSpeech compare:@"third person neutral pronoun"] == 0){
			fancyType = @"3rd Person Neutral Pronoun";
			
		} else if([partOfSpeech compare:@"prep., v."] == 0){
			fancyType = @"Preposition, Verb";
			
		} else if([partOfSpeech compare:@"pn. dual inclusive"] == 0){
			fancyType = @"Pronoun, Dual Inclusive";
			
		} else if([partOfSpeech compare:@"adj., pn."] == 0){
			fancyType = @"Adjective, Pronoun";
			
		} else if([partOfSpeech compare:@"n.,adj."] == 0){
			fancyType = @"Adjective, Noun";
			
		} else if([partOfSpeech compare:@"pn.,adj."] == 0){
			fancyType = @"Adjective, Pronoun";
			
		} else if([partOfSpeech compare:@"root"] == 0){
			fancyType = @"Root";
			
		} else if([partOfSpeech compare:@"prefix"] == 0){
			fancyType = @"Prefix";
			
		} else if([partOfSpeech compare:@"pn., adv."] == 0){
			fancyType = @"Adverb, Pronoun";
			
		} else if([partOfSpeech compare:@"n., adv."] == 0){
			fancyType = @"Noun, Adverb";
			
		} else if([partOfSpeech compare:@"adj., n."] == 0){
			fancyType = @"Adjective, Noun";
			
		} else if([partOfSpeech compare:@"adv., intj."] == 0){
			fancyType = @"Adverb, Interjection";
			
		} else if([partOfSpeech compare:@"v., intj."] == 0){
			fancyType = @"Verb, Interjection";
			
		} else if([partOfSpeech compare:@"dem.,pn."] == 0){
			fancyType = @"Demonstrative, Pronoun";
			
		} else {
			NSLog(@"Unknown: %@ - %@", partOfSpeech, term);
			fancyType = partOfSpeech;
		}
		
		if([[term substringWithRange:NSMakeRange(0, 1)] compare:@"*"] == 0){
			// Non attested form
			term = [term substringWithRange:NSMakeRange(1, [term length] - 1)];
			fancyType = [NSString stringWithFormat:@"%@ - Non-attested root form", fancyType];
			
		}
		
		DictionaryEntry *entry = [DictionaryEntry entryWithName:term type:partOfSpeech definition:definition andFancyType:fancyType];
		[entries addObject:entry];
		if(partOfSpeech){
		
			if([partOfSpeech compare:@"pn."] == 0){
				[entriesPN addObject:entry];
				
			} else if([partOfSpeech compare:@"n."] == 0){
				[entriesN addObject:entry];
				
			} else if([partOfSpeech compare:@"n"] == 0){
				[entriesN addObject:entry];
				
			} else if([partOfSpeech compare:@"v."] == 0){
				[entriesV addObject:entry];
				
			} else if([partOfSpeech compare:@"adj."] == 0){
				[entriesADJ addObject:entry];
				
			} else if([partOfSpeech compare:@"adv."] == 0){
				[entriesADV addObject:entry];
				
			}
		
		}
		
	}
	//[sections addObject:section];
	
	[entries sortUsingFunction:stringSort context:nil];
	[entriesV sortUsingFunction:stringSort context:nil];
	[entriesN sortUsingFunction:stringSort context:nil];
	[entriesPN sortUsingFunction:stringSort context:nil];
	[entriesADJ sortUsingFunction:stringSort context:nil];
	[entriesADV sortUsingFunction:stringSort context:nil];
	
	[self setDictionaryTranslatedContent:entries];
	[self setDictionaryTranslatedContentVerbs:entriesV];
	[self setDictionaryTranslatedContentNouns:entriesN];
	[self setDictionaryTranslatedContentProNouns:entriesPN];
	[self setDictionaryTranslatedContentAdjectives:entriesADJ];
	[self setDictionaryTranslatedContentAdverbs:entriesADV];
	
	
	dictionaryTranslatedContentIndex = [[NSMutableArray alloc] init];
	dictionaryTranslatedContentProNounsIndex = [[NSMutableArray alloc] init];
	dictionaryTranslatedContentNounsIndex = [[NSMutableArray alloc] init];
	dictionaryTranslatedContentVerbsIndex = [[NSMutableArray alloc] init];
	dictionaryTranslatedContentAdjectivesIndex = [[NSMutableArray alloc] init];
	dictionaryTranslatedContentAdverbsIndex = [[NSMutableArray alloc] init];
	
	for(int i=0; i <[dictionaryTranslatedContentProNouns count]; i++){
		
		NSString *uniChar = [[[dictionaryTranslatedContentProNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryTranslatedContentProNouns objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryTranslatedContentProNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = uniChar2;
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryTranslatedContentProNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		if(![dictionaryTranslatedContentProNounsIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryTranslatedContentProNounsIndex addObject:[uniChar capitalizedString]];
		}
		
	}

	for(int i=0; i <[dictionaryTranslatedContentNouns count]; i++){
		
		NSString *uniChar = [[[dictionaryTranslatedContentNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryTranslatedContentNouns objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryTranslatedContentNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = uniChar2;
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryTranslatedContentNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		
		if(![dictionaryTranslatedContentNounsIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryTranslatedContentNounsIndex addObject:[uniChar capitalizedString]];
		}
		
	}
	
	for(int i=0; i <[dictionaryTranslatedContentVerbs count]; i++){
		
		NSString *uniChar = [[[dictionaryTranslatedContentVerbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryTranslatedContentVerbs objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryTranslatedContentVerbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = uniChar2;
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryTranslatedContentVerbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		
		if(![dictionaryTranslatedContentVerbsIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryTranslatedContentVerbsIndex addObject:[uniChar capitalizedString]];
		}
		
	}
	
	for(int i=0; i <[dictionaryTranslatedContentAdjectives count]; i++){
		
		NSString *uniChar = [[[dictionaryTranslatedContentAdjectives objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryTranslatedContentAdjectives objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryTranslatedContentAdjectives objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = uniChar2;
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryTranslatedContentAdjectives objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		
		if(![dictionaryTranslatedContentAdjectivesIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryTranslatedContentAdjectivesIndex addObject:[uniChar capitalizedString]];
		}
		
	}
	
	for(int i=0; i <[dictionaryTranslatedContent count]; i++){
		
		NSString *uniChar = [[[dictionaryTranslatedContent objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryTranslatedContent objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryTranslatedContent objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = uniChar2;
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryTranslatedContent objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		
		if(![dictionaryTranslatedContentIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryTranslatedContentIndex addObject:[uniChar capitalizedString]];
		}
		
	}
	
	for(int i=0; i <[dictionaryTranslatedContentAdverbs count]; i++){
		
		NSString *uniChar = [[[dictionaryTranslatedContentAdverbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryTranslatedContentAdverbs objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryTranslatedContentAdverbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = uniChar2;
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryTranslatedContentAdverbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		
		if(![dictionaryTranslatedContentAdverbsIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryTranslatedContentAdverbsIndex addObject:[uniChar capitalizedString]];
		}
		
	}
	
	//[self setDictionaryActiveContentIndex:indexes];
	
		
}

- (void)loadNaviData {
	//NSURL * url = [NSURL fileURLWithPath:@"NaviDictionary.tsv"];
	
	NSLog(@"Loading Na'vi");
	NSString *path = [[NSBundle mainBundle] pathForResource:@"NaviDictionary" ofType:@"csv"];
	// Do something with the filename.
	NSError *error;
	NSString * fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error ];
	NSCharacterSet *newlineSet;
	NSCharacterSet *splitSet;
	NSScanner *scanner;
	scanner = [NSScanner scannerWithString:fileContents];
	[scanner setCharactersToBeSkipped:[NSCharacterSet whitespaceCharacterSet]];
	newlineSet = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
	splitSet = [NSCharacterSet characterSetWithCharactersInString:@";"];
	//NSMutableArray *sections = [NSMutableArray arrayWithCapacity:30];
	NSMutableArray *entries = [NSMutableArray arrayWithCapacity:150];
	NSMutableArray *entriesN = [NSMutableArray arrayWithCapacity:150];
	NSMutableArray *entriesPN = [NSMutableArray arrayWithCapacity:150];
	NSMutableArray *entriesADJ = [NSMutableArray arrayWithCapacity:150];
	NSMutableArray *entriesV = [NSMutableArray arrayWithCapacity:150];
	NSMutableArray *entriesADV = [NSMutableArray arrayWithCapacity:150];
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
		[lineScanner scanString:@";" intoString:NULL]; 
		[lineScanner scanUpToCharactersFromSet:splitSet intoString:&definition];
		[lineScanner scanString:@";" intoString:NULL]; 
		[lineScanner scanUpToCharactersFromSet:splitSet intoString:&partOfSpeech]; 
		 
		//NSLog(@"%@ ||| %@ ||| %@", term, partOfSpeech, definition);
		//NSLog(@"%@ - %@", term, partOfSpeech);
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
		
		NSString *fancyType;
		
		
		if([partOfSpeech compare:@"pn."] == 0){
			fancyType = @"Pronoun";		
			
		} else if([partOfSpeech compare:@"n."] == 0){
			fancyType = @"Noun";			
			
		} else if([partOfSpeech compare:@"v."] == 0){
			fancyType = @"Verb";			
			
		} else if([partOfSpeech compare:@"adj."] == 0){
			fancyType = @"Adjective";			
			
		} else if([partOfSpeech compare:@"adv."] == 0){
			fancyType = @"Adverb";	
			
		} else if([partOfSpeech compare:@"part."] == 0){
			fancyType = @"Participle";
			
		} else if([partOfSpeech compare:@"part. for"] == 0){
			fancyType = @"Participle";
			
		} else if([partOfSpeech compare:@"prep."] == 0){
			fancyType = @"Preposition";	
			
		} else if([partOfSpeech compare:@"dem."] == 0){
			fancyType = @"Demonstrative";
			
		} else if([partOfSpeech compare:@"conj."] == 0){
			fancyType = @"Conjunction";
			
		} else if([partOfSpeech compare:@"adp."] == 0){
			fancyType = @"Adpositional Affix";
			
		} else if([partOfSpeech compare:@"inter."] == 0){
			fancyType = @"Interrogative";
			
		} else if([partOfSpeech compare:@"prop.b"] == 0){
			fancyType = @"Proper Noun";
			
		} else if([partOfSpeech compare:@"prop.n."] == 0){
			fancyType = @"Proper Noun";
			
		} else if([partOfSpeech compare:@"prop.n"] == 0){
			fancyType = @"Proper Noun";
			
		} else if([partOfSpeech compare:@"num."] == 0){
			fancyType = @"Number";
			
		} else if([partOfSpeech compare:@"n., intj."] == 0){
			fancyType = @"Noun, Interjection";
			
		} else if([partOfSpeech compare:@"intj."] == 0){
			fancyType = @"Interjection";
			
		} else if([partOfSpeech compare:@"adv., adj."] == 0){
			fancyType = @"Adverb, Adjective";
			
		} else if([partOfSpeech compare:@"phrase"] == 0){
			fancyType = @"Phrase";
			
		} else if([partOfSpeech compare:@"affix inter. marker"] == 0){
			fancyType = @"Interrogative Affix";
			
		} else if([partOfSpeech compare:@"n"] == 0){
			fancyType = @"Noun";
			
		} else if([partOfSpeech compare:@"third person neutral pronoun"] == 0){
			fancyType = @"3rd Person Neutral Pronoun";
			
		} else if([partOfSpeech compare:@"prep., v."] == 0){
			fancyType = @"Preposition, Verb";
			
		} else if([partOfSpeech compare:@"pn. dual inclusive"] == 0){
			fancyType = @"Pronoun, Dual Inclusive";
			
		} else if([partOfSpeech compare:@"adj., pn."] == 0){
			fancyType = @"Adjective, Pronoun";
			
		} else if([partOfSpeech compare:@"n.,adj."] == 0){
			fancyType = @"Adjective, Noun";
			
		} else if([partOfSpeech compare:@"pn.,adj."] == 0){
			fancyType = @"Adjective, Pronoun";
			
		} else if([partOfSpeech compare:@"root"] == 0){
			fancyType = @"Root";
			
		} else if([partOfSpeech compare:@"prefix"] == 0){
			fancyType = @"Prefix";
			
		} else if([partOfSpeech compare:@"pn., adv."] == 0){
			fancyType = @"Adverb, Pronoun";
			
		} else if([partOfSpeech compare:@"n., adv."] == 0){
			fancyType = @"Noun, Adverb";
			
		} else if([partOfSpeech compare:@"adj., n."] == 0){
			fancyType = @"Adjective, Noun";
			
		} else if([partOfSpeech compare:@"adv., intj."] == 0){
			fancyType = @"Adverb, Interjection";
			
		} else if([partOfSpeech compare:@"v., intj."] == 0){
			fancyType = @"Verb, Interjection";
			
		} else if([partOfSpeech compare:@"dem.,pn."] == 0){
			fancyType = @"Demonstrative, Pronoun";
			
		} else {
			NSLog(@"Unknown: %@ - %@", partOfSpeech, term);
			fancyType = partOfSpeech;
		}
		
		if([[term substringWithRange:NSMakeRange(0, 1)] compare:@"*"] == 0){
			// Non attested form
			term = [term substringWithRange:NSMakeRange(1, [term length] - 1)];
			fancyType = [NSString stringWithFormat:@"%@ - Non-attested root form", fancyType];
			
		}		
		
		DictionaryEntry *entry = [DictionaryEntry entryWithName:term type:partOfSpeech definition:definition andFancyType:fancyType];
		
		[entries addObject:entry];
		if(partOfSpeech){
			if([partOfSpeech compare:@"pn."] == 0){
				[entriesPN addObject:entry];
				
			} else if([partOfSpeech compare:@"n."] == 0 || [partOfSpeech compare:@"prop.n"] == 0){
				[entriesN addObject:entry];
				
			} else if([partOfSpeech compare:@"v."] == 0){
				[entriesV addObject:entry];
				
			} else if([partOfSpeech compare:@"adj."] == 0){
				[entriesADJ addObject:entry];
				
			} else if([partOfSpeech compare:@"adv."] == 0){
				[entriesADV addObject:entry];
				
			} else if([partOfSpeech compare:@"n"] == 0){
				[entriesN addObject:entry];
				
			}
		}
	}
	//[entries addObject:section];
	
	[self setDictionaryContent:entries];
	[self setDictionaryContentVerbs:entriesV];
	[self setDictionaryContentNouns:entriesN];
	[self setDictionaryContentProNouns:entriesPN];
	[self setDictionaryContentAdjectives:entriesADJ];
	[self setDictionaryContentAdverbs:entriesADV];
	
	
	dictionaryContentIndex = [[NSMutableArray alloc] init];
	dictionaryContentProNounsIndex = [[NSMutableArray alloc] init];
	dictionaryContentNounsIndex = [[NSMutableArray alloc] init];
	dictionaryContentVerbsIndex = [[NSMutableArray alloc] init];
	dictionaryContentAdjectivesIndex = [[NSMutableArray alloc] init];
	dictionaryContentAdverbsIndex = [[NSMutableArray alloc] init];
	
	for(int i=0; i <[dictionaryContentProNouns count]; i++){
		
		NSString *uniChar = [[[dictionaryContentProNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryContentProNouns objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryContentProNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = uniChar2;
		} else if([uniChar compare:@"-"] == 0){
			//Pesky *
			uniChar = [[[dictionaryContentProNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(2, 1)];
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryContentProNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		
		if(![dictionaryContentProNounsIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryContentProNounsIndex addObject:[uniChar capitalizedString]];
		}
		
	}
	
	for(int i=0; i <[dictionaryContentNouns count]; i++){
		
		NSString *uniChar = [[[dictionaryContentNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryContentNouns objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryContentNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = uniChar2;
		} else if([uniChar compare:@"-"] == 0){
			//Pesky *
			uniChar = [[[dictionaryContentNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(2, 1)];
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryContentNouns objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		
		if(![dictionaryContentNounsIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryContentNounsIndex addObject:[uniChar capitalizedString]];
		}
		
	}
	
	for(int i=0; i <[dictionaryContentVerbs count]; i++){
		
		NSString *uniChar = [[[dictionaryContentVerbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryContentVerbs objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryContentVerbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = [[[dictionaryContentVerbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		} else if([uniChar compare:@"-"] == 0){
			//Pesky *
			uniChar = [[[dictionaryContentVerbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(2, 1)];
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryContentVerbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		
		if(![dictionaryContentVerbsIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryContentVerbsIndex addObject:[uniChar capitalizedString]];
		}
		
	}
	
	for(int i=0; i <[dictionaryContentAdjectives count]; i++){
		
		NSString *uniChar = [[[dictionaryContentAdjectives objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryContentAdjectives objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryContentAdjectives objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = uniChar2;
		} else if([uniChar compare:@"-"] == 0){
			//Pesky *
			uniChar = [[[dictionaryContentAdjectives objectAtIndex:i] entryName] substringWithRange:NSMakeRange(2, 1)];
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryContentAdjectives objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		
		if(![dictionaryContentAdjectivesIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryContentAdjectivesIndex addObject:[uniChar capitalizedString]];
		}
		
	}
	
	for(int i=0; i <[dictionaryContent count]; i++){
		
		NSString *uniChar = [[[dictionaryContent objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryContent objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryContent objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = uniChar2;
		} else if([uniChar compare:@"-"] == 0){
			//Pesky *
			uniChar = [[[dictionaryContent objectAtIndex:i] entryName] substringWithRange:NSMakeRange(2, 1)];
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryContent objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		
		if(![dictionaryContentIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryContentIndex addObject:[uniChar capitalizedString]];
		}
		
	}
	
	for(int i=0; i <[dictionaryContentAdverbs count]; i++){
		
		NSString *uniChar = [[[dictionaryContentAdverbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 1)];
		NSString *uniChar2 = @"";
		if([[[dictionaryContentAdverbs objectAtIndex:i] entryName] length] > 1){
			uniChar2 = [[[dictionaryContentAdverbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(1, 1)];
		}
		if([uniChar compare:@"*"] == 0){
			//Pesky *
			uniChar = uniChar2;
		} else if([uniChar compare:@"-"] == 0){
			//Pesky *
			uniChar = [[[dictionaryContentAdverbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(2, 1)];
		} else if((([uniChar compare:@"p"] == 0 || [uniChar compare:@"k"] == 0 || [uniChar compare:@"t"] == 0) && ([uniChar2 compare:@"x"] == 0)) || ([uniChar compare:@"n"] == 0) && ([uniChar2 compare:@"g"] == 0) ){
			//Pesky *
			uniChar = [[[dictionaryContentAdverbs objectAtIndex:i] entryName] substringWithRange:NSMakeRange(0, 2)];
		}
		
		if(![dictionaryContentAdverbsIndex containsObject:[uniChar capitalizedString]]){
			[dictionaryContentAdverbsIndex addObject:[uniChar capitalizedString]];
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

