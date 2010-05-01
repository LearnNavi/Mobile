//
//  DictionaryTableViewController.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 LearnNa'vi.org Community. All rights reserved.
//

#import "DictionaryEntry.h"
#import "DictionaryTableViewController.h"
#import "DictionaryEntryViewController.h"
#import "UIViewAdditions.h"

@implementation DictionaryTableViewController


@synthesize dictionaryContent, filteredDictionaryContent, dictionaryContentIndex; 
@synthesize savedSearchTerm, savedScopeButtonIndex, searchWasActive, viewController, segmentedControl, currentMode;

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
				
				
				break;
			case 1:
				// Nouns
				
				break;
			case 2:
				// Pronouns
				
				break;
			case 3:
				// Verbs
				
				break;
			case 4:
				// Adjectives
				
				break;
			case 5:
				// Adverbs
				
				break;
			default:
				break;
				
		}
	} else {
		switch(segmentedControl.selectedSegmentIndex) {
			case 0:
				// All
				// Do nothing
				
				
				break;
			case 1:
				// Nouns
				
				
				break;
			case 2:
				// Pronouns
				
				break;
			case 3:
				// Verbs
				
				break;
			case 4:
				// Adjectives
				
				break;
			case 5:
				// Adverbs
				
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
	
	//Need a more elegant way to load...
	//
	//[self loadData];
	//[self.tableView reloadData];

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
		return [dictionaryContentIndex objectAtIndex:section];
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
		return [dictionaryContentIndex count];
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
		NSString *alphabet = [[dictionaryContentIndex objectAtIndex:section] capitalizedString];
		
		NSPredicate *predicate;
		//---get all states beginning with the letter---
		
		predicate = [NSPredicate predicateWithFormat:@"SELF.alpha like %@", alphabet];
		
		NSArray *entries = [dictionaryContent filteredArrayUsingPredicate:predicate];
		
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
        
		
		//---get the letter in the current section---
		NSString *alphabet = [dictionaryContentIndex objectAtIndex:[indexPath section]];
		
		NSPredicate *predicate;
		//---get all states beginning with the letter---
		
		predicate = [NSPredicate predicateWithFormat:@"SELF.alpha like %@", alphabet];
		
		NSArray *entries =  [dictionaryContent filteredArrayUsingPredicate:predicate];

		
		if ([entries count]>0) {
			//---extract the relevant state from the states object---
			entry = [entries objectAtIndex:indexPath.row];
		}
		
		
    }
	UILabel *lblTemp1 = (UILabel *)[cell viewWithTag:1];
	
	UILabel *lblTemp2 = (UILabel *)[cell viewWithTag:2];

			
	lblTemp1.text = entry.entryName;
	lblTemp2.text = entry.english_definition;
	
	
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
		NSString *alphabet = [dictionaryContentIndex objectAtIndex:[indexPath section]];
		NSPredicate *predicate;
		//---get all states beginning with the letter---
			
		predicate = [NSPredicate predicateWithFormat:@"SELF.alpha like %@", alphabet];
		
		NSArray *entries = [dictionaryContent filteredArrayUsingPredicate:predicate];
		
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
	
	
	for (DictionaryEntry *entry in dictionaryContent) {
		
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
		return dictionaryContentIndex;
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
	// Data preloaded in sqlite database;
	// need to load it into memory
	//
	databaseName = @"dictionary.sqlite";
	
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	
	// Execute the "checkAndCreateDatabase" function
	[self checkAndCreateDatabase];
	
	// Query the database for all animal records and construct the "animals" array
	[self readEntriesFromDatabase];
	
	

}

-(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success) return;
	
	// If not then proceed to copy the database from the application to the users filesystem
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
	[fileManager release];
}

-(void) readEntriesFromDatabase {
	// Setup the database object
	sqlite3 *database;
	
	// Init the animals Array
	NSMutableArray *content = [[NSMutableArray alloc] init];
	// Open the database from the users filessytem
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
		const char *sqlStatement3 = "SELECT count(*) FROM entries";
		
		sqlite3_stmt *compiledStatement3;
		int sqlResult3 = sqlite3_prepare_v2(database, sqlStatement3, -1, &compiledStatement3, NULL);
		if(sqlResult3 == SQLITE_OK) {
			while(sqlite3_step(compiledStatement3) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aCount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement3, 0)];
			
				NSLog(@"Count %@",aCount);
			}
		}
		
		// Setup the SQL Statement and compile it for faster access
		const char *sqlStatement = "SELECT entries.entry_name, entries.navi_definition, entries.english_definition, entries.part_of_speech, entries.ipa, entries.image, entries.audio, fancy_parts_of_speech.description, entries.alpha FROM entries,fancy_parts_of_speech WHERE entries.part_of_speech = fancy_parts_of_speech.part_of_speech";
		//const char *sqlStatement = "SELECT * FROM entries";
		sqlite3_stmt *compiledStatement;
		int sqlResult = sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL);
		if(sqlResult == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aEntry_Name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				NSString *aNavi_definition = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				NSString *aEnglish_definition = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				NSString *aPart_of_speech = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
				NSString *aIpa = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
				NSString *aImageURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
				NSString *aAudioURL = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
				NSString *aFancy_type = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];
				NSString *aAlpha = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 8)];
				//NSString *aFancy_type = @"";
				// Create a new animal object with the data from the database
				DictionaryEntry *entry = [DictionaryEntry entryWithName:aEntry_Name english_definition:aEnglish_definition navi_definition:aNavi_definition part_of_speech:aPart_of_speech ipa:aIpa imageURL:aImageURL audioURL:aAudioURL andFancyType:aFancy_type alpha:aAlpha];
				// Add the animal object to the animals Array
				[content addObject:entry];
				
				//[entry release];
			}
		} else {
			NSLog(@"Error1");
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement);
		NSMutableArray *contentIndex = [[NSMutableArray alloc] init];
		
		const char *sqlStatement2 = "SELECT alpha FROM entries GROUP BY alpha";
		//const char *sqlStatement = "SELECT * FROM entries";
		sqlite3_stmt *compiledStatement2;
		sqlResult = sqlite3_prepare_v2(database, sqlStatement2, -1, &compiledStatement2, NULL);
		if(sqlResult == SQLITE_OK) {
			// Loop through the results and add them to the feeds array
			while(sqlite3_step(compiledStatement2) == SQLITE_ROW) {
				// Read the data from the result row
				NSString *aAlpha = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement2, 0)];
				
				//NSString *aFancy_type = @"";
				// Create a new animal object with the data from the database
				[contentIndex addObject:aAlpha];

				
			}
		} else {
			NSLog(@"Error2");
		}
		// Release the compiled statement from memory
		sqlite3_finalize(compiledStatement2);
		
		[self setDictionaryContent:content];
		dictionaryContentIndex = contentIndex;
		
	}
	sqlite3_close(database);
	
	
	
}


- (void)dealloc {
	[dictionaryContent dealloc];
	[filteredDictionaryContent dealloc];
	 
    [super dealloc];
}


@end

