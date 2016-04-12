//
//  TabBarController.m
//  My Shopping List
//
//  Created by Joel Arnott on 7/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

/* UIViewController
 *********************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set the selection tint color for our tabs
    self.tabBar.tintColor = [UIColor whiteColor];
    /*for (UITabBarItem *item in self.tabBar.items) {
        item.tintColor
    }*/
    
    // Set the selection background color for our tabs
    // To do this we need to create a solid color image
    CGSize tabSize = CGSizeMake(self.tabBar.frame.size.width/2,
                                self.tabBar.frame.size.height);
    
    UIGraphicsBeginImageContextWithOptions(tabSize, false, 0);
    [COLOR_HIGHLIGHT setFill];
    UIRectFill(CGRectMake(0, 0, tabSize.width, tabSize.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.tabBar.selectionIndicatorImage = image;
}

@end
