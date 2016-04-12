//
//  ItemsViewController.m
//  My Shopping List
//
//  Created by Joel Arnott on 7/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import "ItemsViewController.h"

@interface ItemsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation ItemsViewController

/* UIViewController
 *********************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get context
    self.context = [DataController sharedDataController].managedObjectContext;
    
    // Setup table
    self.tableView.allowsSelection = NO;
    
    // Reload table
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set title
    self.navigationItem.title = self.category.name;
}

/* UITextFieldDelegate
 *********************************************************************/

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Create item
    // TODO: Add error checking
    MSLItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"MSLItem" inManagedObjectContext:self.context];
    item.name = textField.text;
    item.itemCategory = self.category;
    
    [self.items addObject:item];
    self.category.items = [NSSet setWithArray:self.items];
    
    [self.context save:nil];
    
    // Clear text field
    textField.text = @"";
    
    // Refresh
    [self.tableView reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

/* UITableViewDataSource
 *********************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result = 1;
    
    // Load items
    // TODO: Move sorting/filtering to a common area to reduce code duplication and prevent needing to sort the same data repeatedly
    self.items = [[[self.category.items allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
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
    cell.textLabel.text = item.name;
    cell.textLabel.highlightedTextColor = COLOR_HIGHLIGHT_TEXT;
    
    return cell;
}

/* UITableViewDelegate
 *********************************************************************/

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete
        
        // Delete item
        // TODO: Add error checking
        MSLItem *item = self.items[indexPath.row];
        [self.items removeObjectAtIndex:indexPath.row];
        self.category.items = [NSSet setWithArray:self.items];
        
        [self.context deleteObject:item];
        [self.context save:nil];
        
        // Refresh
        [self.tableView reloadData];
    }
}

@end
