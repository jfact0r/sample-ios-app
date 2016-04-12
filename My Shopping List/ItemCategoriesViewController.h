//
//  ItemCategoriesViewController.h
//  My Shopping List
//
//  Created by Joel Arnott on 7/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemCategoriesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *noDataView;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

