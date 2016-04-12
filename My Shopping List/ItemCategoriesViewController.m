//
//  ItemCategoriesViewController.m
//  My Shopping List
//
//  Created by Joel Arnott on 7/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import "ItemCategoriesViewController.h"
#import "ItemsViewController.h"

@interface ItemCategoriesViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *itemCategories;

@end

@implementation ItemCategoriesViewController

/* UIViewController
 *********************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Get context
    self.context = [DataController sharedDataController].managedObjectContext;
    
    // Reload table
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set title
    self.navigationItem.title = self.title;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pass on item category
    ItemsViewController *vc = segue.destinationViewController;
    vc.category = sender;
}

/* UITextFieldDelegate
 *********************************************************************/

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Create category
    // TODO: Add error checking
    MSLItemCategory *itemCategory = [NSEntityDescription insertNewObjectForEntityForName:@"MSLItemCategory" inManagedObjectContext:self.context];
    itemCategory.name = textField.text;
    
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
    
    // Load categories
    // TODO: Add error checking
    // TODO: Move sorting/filtering to a common area to reduce code duplication and prevent needing to sort the same data repeatedly
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MSLItemCategory"];
    self.itemCategories = [[self.context executeFetchRequest:fetchRequest error:nil] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] localizedCompare:[obj2 name]];
    }];
    
    // Check if we have any categories
    if ([self.itemCategories count]) {
        // Have categories
        
        // Hide our "no data" message
        self.noDataView.hidden = YES;
    } else {
        // No categories
        
        // Show our "no data" message
        self.noDataView.hidden = NO;
        
        // No sections
        result = 0;
    }
    
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.itemCategories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Get data
    MSLItemCategory *itemCategory = self.itemCategories[indexPath.row];
    
    // Update cell
    cell.textLabel.text = itemCategory.name;
    cell.textLabel.highlightedTextColor = COLOR_HIGHLIGHT_TEXT;
    
    return cell;
}

/* UITableViewDelegate
 *********************************************************************/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselect
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Get data
    MSLItemCategory *itemCategory = self.itemCategories[indexPath.row];
    
    // Segue
    [self performSegueWithIdentifier:@"selectCategory" sender:itemCategory];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete
        
        // Delete item category
        // TODO: Add error checking
        MSLItemCategory *itemCategory = self.itemCategories[indexPath.row];
        
        [self.context deleteObject:itemCategory];
        [self.context save:nil];
        
        // Refresh
        [self.tableView reloadData];
    }
}

@end
