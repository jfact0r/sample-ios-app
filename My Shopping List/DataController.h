//
//  DataController.h
//  My Shopping List
//
//  Created by Joel Arnott on 7/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DataController;

@interface DataController : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (DataController *)sharedDataController;

@end
