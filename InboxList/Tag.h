//
//  Tag.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/06.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Filter, Item;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * section;
@property (nonatomic, retain) NSSet *filters;
@property (nonatomic, retain) NSSet *items;
@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addFiltersObject:(Filter *)value;
- (void)removeFiltersObject:(Filter *)value;
- (void)addFilters:(NSSet *)values;
- (void)removeFilters:(NSSet *)values;

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
