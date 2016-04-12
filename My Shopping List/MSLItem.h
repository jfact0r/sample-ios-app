//
//  MSLItem.h
//  My Shopping List
//
//  Created by Joel Arnott on 8/04/2016.
//  Copyright © 2016 Joel Arnott. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MSLItemCategory, MSLList;

NS_ASSUME_NONNULL_BEGIN

@interface MSLItem : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "MSLItem+CoreDataProperties.h"
