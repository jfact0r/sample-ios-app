//
//  ListViewController.m
//  My Shopping List
//
//  Created by Joel Arnott on 7/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import "ListViewController.h"
#import "EditListViewController.h"

@interface ListViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSMutableArray *items;
@property (strong, nonatomic) NSMutableSet *checkedItems;

@end

@implementation ListViewController

- (void)editButtonTapped:(id)sender
{
    // Segue
    [self performSegueWithIdentifier:@"edit" sender:nil];
}

/* UIViewController
 *********************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add edit button
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editButtonTapped:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    // Set back button
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Get context
    self.context = [DataController sharedDataController].managedObjectContext;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Setup checked items
    self.checkedItems = [NSMutableSet set];
    
    // Set title
    self.navigationItem.title = self.list.name;
    
    // Reload table
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass on list
    EditListViewController *vc = segue.destinationViewController;
    vc.list = self.list;
}

/* UITableViewDataSource
 *********************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result = 1;
    
    // Load items
    // TODO: Move sorting/filtering to a common area to reduce code duplication and prevent needing to sort the same data repeatedly
    self.items = [[[self.list.items allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] localizedCompare:[obj2 name]];
    }] mutableCopy];
    
    // Check if we have any items
    if ([self.items count]) {
        // Have items
        
        // Hide our "no data" message
        self.noDataView.hidden = YES;
    } else {
        // No items
        
        // Show our "no data" message
        self.noDataView.hidden = NO;
        
        // No sections
        result = 0;
    }
    
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Get data
    MSLItem *item = self.items[indexPath.row];
    
    // Update cell
    cell.textLabel.highlightedTextColor = COLOR_HIGHLIGHT_TEXT;
    
    // Check if this item is checked
    if ([self.checkedItems containsObject:item]) {
        // Checked
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:item.name];
        [text addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, [item.name length])];
        cell.textLabel.attributedText = text;
    } else {
        // Not checked
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.attributedText = nil;
        cell.textLabel.text = item.name;
    }
    
    return cell;
}

/* UITableViewDelegate
 *********************************************************************/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get data
    MSLItem *item = self.items[indexPath.row];
    
    // Check 'em
    if (![self.checkedItems containsObject:item]) {
        [self.checkedItems addObject:item];
    } else {
        [self.checkedItems removeObject:item];
    }
    
    // Reload
    [tableView reloadData];
}

@end
