//
//  EditListViewController.m
//  My Shopping List
//
//  Created by Joel Arnott on 7/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import "EditListViewController.h"

@interface EditListViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *itemCategories;
@property (strong, nonnull) NSTimer *searchTimer;

@end

@implementation EditListViewController

/* UIViewController
 *********************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get context
    self.context = [DataController sharedDataController].managedObjectContext;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set title
    self.navigationItem.title = [NSString stringWithFormat:@"Edit %@", self.list.name];
    
    // Reload table
    [self.tableView reloadData];
}

/* UITextFieldDelegate
 *********************************************************************/

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Refresh
    [self.tableView reloadData];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Refresh after delay
    [self.searchTimer invalidate];
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:NO];
    
    // Done
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    // Refresh after delay
    [self.searchTimer invalidate];
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self.tableView selector:@selector(reloadData) userInfo:nil repeats:NO];
    
    return YES;
}

/* UITableViewDataSource
 *********************************************************************/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger result = 0;
    
    // Load categories
    // TODO: Error checking
    // TODO: Move sorting/filtering to a common area to reduce code duplication and prevent needing to sort the same data repeatedly
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MSLItemCategory"];
    self.itemCategories = [[self.context executeFetchRequest:fetchRequest error:nil] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] localizedCompare:[obj2 name]];
    }];
    
    NSString *filterText = self.textField.text;
    if ([filterText length]) {
        self.itemCategories = [self.itemCategories filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> *bindings) {
            return [[[[evaluatedObject items] allObjects] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> *bindings) {
                NSRange range = [[evaluatedObject name] rangeOfString:filterText options:NSCaseInsensitiveSearch];
                return range.location != NSNotFound;
            }]] count];
        }]];
    }
    
    // Set result
    result = [self.itemCategories count];
    
    // Check if we have any categories
    if (result) {
        // Have categories
        
        // Hide our "no data" message
        self.noDataView.hidden = YES;
    } else {
        // No categories
        
        // Show our "no data" message
        self.noDataView.hidden = NO;
    }
    
    return result;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.itemCategories[section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Get data
    NSArray *items = [[self.itemCategories[section] items] allObjects];
    
    NSString *filterText = self.textField.text;
    if ([filterText length]) {
        items = [items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> *bindings) {
            NSRange range = [[evaluatedObject name] rangeOfString:filterText options:NSCaseInsensitiveSearch];
            return range.location != NSNotFound;
        }]];
    }
    
    return [items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Get data
    // TODO: Move sorting/filtering to a common area to reduce code duplication and prevent needing to sort the same data repeatedly
    NSArray *items = [[[self.itemCategories[indexPath.section] items] allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] localizedCompare:[obj2 name]];
    }];
    
    NSString *filterText = self.textField.text;
    if ([filterText length]) {
        items = [items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> *bindings) {
            NSRange range = [[evaluatedObject name] rangeOfString:filterText options:NSCaseInsensitiveSearch];
            return range.location != NSNotFound;
        }]];
    }
    
    MSLItem *item = items[indexPath.row];
    
    // Update cell
    cell.textLabel.text = item.name;
    cell.textLabel.highlightedTextColor = COLOR_HIGHLIGHT_TEXT;
    
    // Handle adding to our list
    if ([self.list.items containsObject:item]) {
        // In our list
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        // Not in our list
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    // TODO: Move sorting/filtering to a common area to reduce code duplication and prevent needing to sort the same data repeatedly
    NSArray *items = [[[self.itemCategories[indexPath.section] items] allObjects] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] localizedCompare:[obj2 name]];
    }];
    
    NSString *filterText = self.textField.text;
    if ([filterText length]) {
        items = [items filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary<NSString *,id> *bindings) {
            NSRange range = [[evaluatedObject name] rangeOfString:filterText options:NSCaseInsensitiveSearch];
            return range.location != NSNotFound;
        }]];
    }
    
    MSLItem *item = items[indexPath.row];
    
    // Handle adding to our list
    NSMutableSet *set = [self.list.items mutableCopy];
    if ([self.list.items containsObject:item]) {
        // In our list
        [set removeObject:item];
    } else {
        // Not in our list
        [set addObject:item];
    }
    self.list.items = set;
    
    [self.context save:nil];
    
    // Refresh
    [self.tableView reloadData];
}

@end
