//
//  DictionaryTableViewController.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DictionaryEntry.h"
#import "DictionaryViewController.h"
#import "DictionaryTableViewController.h"


@implementation DictionaryTableViewController


@synthesize dictionaryContent, filteredDictionaryContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive, viewController, segmentedControl;

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
    [super viewDidLoad];
	listOfItems = [[NSMutableArray alloc] init];
	[self loadData];
	
	
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	// create a filtered list that will contain products for the search results table.
	self.filteredDictionaryContent = [NSMutableArray arrayWithCapacity:[self.dictionaryContent count]];
	
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
	self.title = @"Na'vi Dictionary";
	
	
	
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
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	[[self navigationController] setToolbarHidden:NO animated:YES];

}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

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
	self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
	
	self.filteredDictionaryContent = nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	
	switch (section) {
		case 0:
			return @"I";
		case 1:
			return @"K";
			/*
		case 2:
			return @"B";
		case 3:
			return @"C";
		case 4:
			return @"D";
		case 5:
			return @"E";
		case 6:
			return @"F";
		case 7:
			return @"G";
		case 8:
			return @"H";
		case 9:
			return @"I";
		case 10:
			return @"J";
		case 11:
			return @"K";
		case 12:
			return @"L";
		case 13:
			return @"M";
		case 14:
			return @"N";
		case 15:
			return @"O";
		case 16:
			return @"P";
		case 17:
			return @"Q";
		case 18:
			return @"R";
		case 19:
			return @"S";
		case 20:
			return @"T";
		case 21:
			return @"U";
		case 22:
			return @"V";
		case 23:
			return @"W";
		case 24:
			return @"X";
		case 25:
			return @"Y";
		case 26:
			return @"Z";
		case 27:
			return @"0-9";
			 */
		default:
			return @"";
	}
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return [listOfItems count];
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
        NSDictionary *dictionary = [listOfItems objectAtIndex:section];
		NSArray *array = [dictionary objectForKey:@"entries"];
		return [array count];
		//return [self.dictionaryContent count];
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
        NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
		entry = [[dictionary objectForKey:@"entries"] objectAtIndex:indexPath.row];
    }
	
	cell.textLabel.text = entry.entryName;
	return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *detailsViewController = [[UIViewController alloc] init];
    
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
        NSDictionary *dictionary = [listOfItems objectAtIndex:indexPath.section];
		entry = [[dictionary objectForKey:@"entries"] objectAtIndex:indexPath.row];
    }
	detailsViewController.title = entry.entryName;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//[(DictionaryViewController *)[self viewController] dictionaryEntrySelected:entry];
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
	
	
	for (NSDictionary *dict in listOfItems)
	{
		
		for (DictionaryEntry *entry in [dict objectForKey:@"entries"]) {
			
			if ([scope isEqualToString:@"All"] || [entry.type isEqualToString:scope])
			{
				NSComparisonResult result = [entry.entryName compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
				if (result == NSOrderedSame)
				{
					[self.filteredDictionaryContent addObject:entry];
				}
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
	NSLog(@"Loading Data");
	
	
	
	/*
	NSArray *array0 = [[NSArray alloc] initWithObjects:
							 nil];
	NSArray *array1 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array2 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array3 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array4 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array5 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array6 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array7 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array8 = [[NSArray alloc] initWithObjects:
					    nil];
	 */
	NSArray *array9 = [[NSArray alloc] initWithObjects:
					  [DictionaryEntry entryWithName:@"ikran" type:@"Noun" andDefinition:@"banshee"], nil];
	/*
	NSArray *array10 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array11 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array12 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array13 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array14 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array15 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array16 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array17 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array18 = [[NSArray alloc] initWithObjects:
					   nil];
	 */
	NSArray *array19 = [[NSArray alloc] initWithObjects:
					  [DictionaryEntry entryWithName:@"seze" type:@"Noun" andDefinition:@"blue flower"], nil];
	/*
	NSArray *array20 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array21 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array22 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array23 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array24 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array25 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array26 = [[NSArray alloc] initWithObjects:
					   nil];
	NSArray *array27 = [[NSArray alloc] initWithObjects:
					   nil];
	 */
	/*
	NSDictionary *dict0 = [NSDictionary dictionaryWithObject:array0 forKey:@"entries"];
	NSDictionary *dict1 = [NSDictionary dictionaryWithObject:array1 forKey:@"entries"];
	NSDictionary *dict2 = [NSDictionary dictionaryWithObject:array2 forKey:@"entries"];
	NSDictionary *dict3 = [NSDictionary dictionaryWithObject:array3 forKey:@"entries"];
	NSDictionary *dict4 = [NSDictionary dictionaryWithObject:array4 forKey:@"entries"];
	NSDictionary *dict5 = [NSDictionary dictionaryWithObject:array5 forKey:@"entries"];
	NSDictionary *dict6 = [NSDictionary dictionaryWithObject:array6 forKey:@"entries"];
	NSDictionary *dict7 = [NSDictionary dictionaryWithObject:array7 forKey:@"entries"];
	NSDictionary *dict8 = [NSDictionary dictionaryWithObject:array8 forKey:@"entries"];
	 */
	NSDictionary *dict9 = [NSDictionary dictionaryWithObject:array9 forKey:@"entries"];
	/*
	NSDictionary *dict10 = [NSDictionary dictionaryWithObject:array10 forKey:@"entries"];
	NSDictionary *dict11 = [NSDictionary dictionaryWithObject:array11 forKey:@"entries"];
	NSDictionary *dict12 = [NSDictionary dictionaryWithObject:array12 forKey:@"entries"];
	NSDictionary *dict13 = [NSDictionary dictionaryWithObject:array13 forKey:@"entries"];
	NSDictionary *dict14 = [NSDictionary dictionaryWithObject:array14 forKey:@"entries"];
	NSDictionary *dict15 = [NSDictionary dictionaryWithObject:array15 forKey:@"entries"];
	NSDictionary *dict16 = [NSDictionary dictionaryWithObject:array16 forKey:@"entries"];
	NSDictionary *dict17 = [NSDictionary dictionaryWithObject:array17 forKey:@"entries"];
	NSDictionary *dict18 = [NSDictionary dictionaryWithObject:array18 forKey:@"entries"];
	 */
	NSDictionary *dict19 = [NSDictionary dictionaryWithObject:array19 forKey:@"entries"];
	/*
	NSDictionary *dict20 = [NSDictionary dictionaryWithObject:array20 forKey:@"entries"];
	NSDictionary *dict21 = [NSDictionary dictionaryWithObject:array21 forKey:@"entries"];
	NSDictionary *dict22 = [NSDictionary dictionaryWithObject:array22 forKey:@"entries"];
	NSDictionary *dict23 = [NSDictionary dictionaryWithObject:array23 forKey:@"entries"];
	NSDictionary *dict24 = [NSDictionary dictionaryWithObject:array24 forKey:@"entries"];
	NSDictionary *dict25 = [NSDictionary dictionaryWithObject:array25 forKey:@"entries"];
	NSDictionary *dict26 = [NSDictionary dictionaryWithObject:array26 forKey:@"entries"];
	NSDictionary *dict27 = [NSDictionary dictionaryWithObject:array27 forKey:@"entries"];
	*/
	//self.dictionaryContent = listContent;
	/*
	[listOfItems addObject:dict0];
	[listOfItems addObject:dict1];
	[listOfItems addObject:dict2];
	[listOfItems addObject:dict3];
	[listOfItems addObject:dict4];
	[listOfItems addObject:dict5];
	[listOfItems addObject:dict6];
	[listOfItems addObject:dict7];
	[listOfItems addObject:dict8];
	*/
	[listOfItems addObject:dict9];
	/*
	[listOfItems addObject:dict10];
	[listOfItems addObject:dict11];
	[listOfItems addObject:dict12];
	[listOfItems addObject:dict13];
	[listOfItems addObject:dict14];
	[listOfItems addObject:dict15];
	[listOfItems addObject:dict16];
	[listOfItems addObject:dict17];
	[listOfItems addObject:dict18];
	*/
	[listOfItems addObject:dict19];
	/*
	[listOfItems addObject:dict20];
	[listOfItems addObject:dict21];
	[listOfItems addObject:dict22];
	[listOfItems addObject:dict23];
	[listOfItems addObject:dict24];
	[listOfItems addObject:dict25];
	[listOfItems addObject:dict26];
	[listOfItems addObject:dict27];
	*/
	//[navigationController release];
}


- (void)dealloc {
	[dictionaryContent dealloc];
	[filteredDictionaryContent dealloc];
	
    [super dealloc];
}


@end

