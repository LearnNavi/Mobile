//
//  DictionaryTableViewController.m
//  Learn Navi iPhone App
//
//  Created by Michael Gillogly on 1/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DictionaryEntry.h"
#import "DictionaryTableViewController.h"
#import "DictionarySection.h"
#import "DictionaryEntryViewController.h"

@implementation DictionaryTableViewController


@synthesize dictionaryContent, dictionarySections, filteredDictionaryContent, savedSearchTerm, savedScopeButtonIndex, searchWasActive, viewController, segmentedControl;

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
	//listOfItems = [[NSMutableArray alloc] init];
	[self loadData];
	
	/*
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	// create a filtered list that will contain products for the search results table.
	self.filteredDictionaryContent = [NSMutableArray arrayWithCapacity:[self.dictionarySections count]];
	
	// restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm)
	{
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
	*/
	 
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
	DictionarySection *dictSection = [dictionaryContent objectAtIndex:section];
	return [dictSection sectionHeader];	
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Number of sections is the number of regions.
	return [dictionaryContent count];
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
		DictionarySection *dictSection = [dictionaryContent objectAtIndex:section];
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
		DictionarySection *dictSection = [dictionaryContent objectAtIndex:indexPath.section];
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
		DictionarySection *dictSection = [dictionaryContent objectAtIndex:indexPath.section];
		entry = [dictSection.entries objectAtIndex:indexPath.row];
    }
	detailsViewController.title = entry.entryName;
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//[(DictionaryViewController *)[self viewController] dictionaryEntrySelected:entry];
	self.navigationItem.backBarButtonItem =
	[[UIBarButtonItem alloc] initWithTitle:@"Dictionary"
									 style: UIBarButtonItemStyleBordered
									target:nil
									action:nil];
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
	
	//Need to load data in from a file
	DictionarySection *section = [DictionarySection sectionWithHeader:@"I" andEntries:[NSArray arrayWithObjects:[DictionaryEntry entryWithName:@"ikran" type:@"Noun" andDefinition:@"banshee"],
																						   [DictionaryEntry entryWithName:@"irayo" type:@"Noun" andDefinition:@"thank you"], nil]];
	DictionarySection *section1 = [DictionarySection sectionWithHeader:@"S" andEntries:[NSArray arrayWithObjects:[DictionaryEntry entryWithName:@"seze" type:@"Noun" andDefinition:@"blue flower"], nil]];
	DictionarySection *section2 = [DictionarySection sectionWithHeader:@"T" andEntries:[NSArray arrayWithObjects:[DictionaryEntry entryWithName:@"taronyu" type:@"Noun" andDefinition:@"hunter"],
																						   [DictionaryEntry entryWithName:@"tsamsiyu" type:@"Noun" andDefinition:@"warrior"], nil]];

		
	[self setDictionaryContent:[NSArray arrayWithObjects:section, section1, section2, nil]];
			//[navigationController release];
	
	NSLog(@"Loading Data Complete");
}


- (void)dealloc {
	[dictionaryContent dealloc];
	[filteredDictionaryContent dealloc];
	
    [super dealloc];
}


@end

