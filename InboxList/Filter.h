//
//  Filter.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/09/26.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

/**
 * @brief  フィルターオブジェクト
 */
@interface Filter : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSNumber *order;

@property (nonatomic, retain) NSDate *from;
@property (nonatomic, retain) NSDate *interval;

@property (nonatomic, retain) NSNumber *overdue;
@property (nonatomic, retain) NSNumber *today;
@property (nonatomic, retain) NSNumber *future;
@end

@interface Filter (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (BOOL)hasInterval;

- (BOOL)hasAllItem;

@end
