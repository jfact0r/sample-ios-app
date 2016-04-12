//
//  ListViewController.h
//  My Shopping List
//
//  Created by Joel Arnott on 8/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *noDataView;

@property (strong, nonatomic) MSLList *list;

@end
