//
//  Tag.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/09/26.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Filter, Item;

/**
 * @brief  タグオブジェクト
 */
@interface Tag : NSManagedObject

@property (nonatomic, retain) NSNumber * section;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Filter *filter;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) NSNumber* order;

@end

@interface Tag (CoreDataGeneratedAccessors)

- (void)addItemsObject:(Item *)value;
- (void)removeItemsObject:(Item *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

/// @todo 期限切れのアイテム数を数える
-(NSInteger)countItemsOfOverDue;

@end
