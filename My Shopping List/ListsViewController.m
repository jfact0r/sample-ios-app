//
//  ListsViewController.m
//  My Shopping List
//
//  Created by Joel Arnott on 7/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import "ListsViewController.h"
#import "ListViewController.h"

@interface ListsViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSArray *lists;

@end

@implementation ListsViewController

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
    ListViewController *vc = segue.destinationViewController;
    vc.list = sender;
}

/* UITextFieldDelegate
 *********************************************************************/

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Create list
    // TODO: Add error checking
    MSLList *list = [NSEntityDescription insertNewObjectForEntityForName:@"MSLList" inManagedObjectContext:self.context];
    list.name = textField.text;
    
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
    
    // Load lists
    // TODO: Add error checking
    // TODO: Move sorting/filtering to a common area to reduce code duplication and prevent needing to sort the same data repeatedly
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"MSLList"];
    self.lists = [[self.context executeFetchRequest:fetchRequest error:nil] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 name] localizedCompare:[obj2 name]];
    }];
    
    // Check if we have any lists
    if ([self.lists count]) {
        // Have lists
        
        // Hide our "no data" message
        self.noDataView.hidden = YES;
    } else {
        // No lists
        
        // Show our "no data" message
        self.noDataView.hidden = NO;
        
        // No sections
        result = 0;
    }
    
    return result;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.lists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Get data
    MSLList *list = self.lists[indexPath.row];
    
    // Update cell
    cell.textLabel.text = list.name;
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
    MSLList *list = self.lists[indexPath.row];
    
    // Segue
    [self performSegueWithIdentifier:@"selectList" sender:list];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete
        
        // Delete list
        // TODO: Add error checking
        MSLList *list = self.lists[indexPath.row];
        
        [self.context deleteObject:list];
        [self.context save:nil];
        
        // Refresh
        [self.tableView reloadData];
    }
}

@end
