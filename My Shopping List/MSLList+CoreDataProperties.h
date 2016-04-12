//
//  MSLList+CoreDataProperties.h
//  My Shopping List
//
//  Created by Joel Arnott on 8/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MSLList.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSLList (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSSet<MSLItem *> *items;

@end

@interface MSLList (CoreDataGeneratedAccessors)

- (void)addItemsObject:(MSLItem *)value;
- (void)removeItemsObject:(MSLItem *)value;
- (void)addItems:(NSSet<MSLItem *> *)values;
- (void)removeItems:(NSSet<MSLItem *> *)values;

@end

NS_ASSUME_NONNULL_END
