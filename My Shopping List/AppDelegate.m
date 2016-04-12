//
//  AppDelegate.m
//  My Shopping List
//
//  Created by Joel Arnott on 7/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/* UIApplicationDelegate
 *********************************************************************/

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup Data Controller
    self.dataController = [DataController sharedDataController];
    
    // Setup tab bar appearance
    [UITabBar appearance].tintColor = COLOR_HIGHLIGHT_TEXT;
    
    // Setup navigation bar appearance
    [UINavigationBar appearance].barTintColor = COLOR_LIGHT;
    [UINavigationBar appearance].tintColor = COLOR_HIGHLIGHT;
    [UINavigationBar appearance].titleTextAttributes = @{ NSForegroundColorAttributeName : COLOR_HIGHLIGHT };
    
    // Setup table view appearance
    UIView *tableViewCellSelectedBackgroundView = [[UIView alloc] init];
    tableViewCellSelectedBackgroundView.backgroundColor = COLOR_HIGHLIGHT;
    [UITableViewCell appearance].selectedBackgroundView = tableViewCellSelectedBackgroundView;
    
    [UITableViewCell appearance].tintColor = COLOR_HIGHLIGHT;
    
    // Done
    return YES;
}

@end
