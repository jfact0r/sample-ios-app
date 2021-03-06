//
//  DataController.m
//  My Shopping List
//
//  Created by Joel Arnott on 7/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import "DataController.h"

@implementation DataController

/* DataController
 *********************************************************************/

+ (DataController *)sharedDataController
{
    static DataController *dataController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataController = [[DataController alloc] init];
    });
    
    return dataController;
}

/* NSObject
 *********************************************************************/

- (id)init
{
    if ((self = [super init])) {
        // Initialise Core Data
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        NSAssert(mom != nil, @"Error initializing Managed Object Model");
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
        NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [moc setPersistentStoreCoordinator:psc];
        [self setManagedObjectContext:moc];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSError *error = nil;
            NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
            NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
            NSAssert(store != nil, @"Error initializing PSC: %@\n%@", [error localizedDescription], [error userInfo]);
        });
    }
    return self;
}

@end
