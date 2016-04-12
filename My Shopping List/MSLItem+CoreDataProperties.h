//
//  MSLItem+CoreDataProperties.h
//  My Shopping List
//
//  Created by Joel Arnott on 8/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MSLItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface MSLItem (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) MSLItemCategory *itemCategory;
@property (nullable, nonatomic, retain) NSSet<MSLList *> *lists;

@end

@interface MSLItem (CoreDataGeneratedAccessors)

- (void)addListsObject:(MSLList *)value;
- (void)removeListsObject:(MSLList *)value;
- (void)addLists:(NSSet<MSLList *> *)values;
- (void)removeLists:(NSSet<MSLList *> *)values;

@end

NS_ASSUME_NONNULL_END
