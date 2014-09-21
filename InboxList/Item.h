//
//  Item.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/06.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

@interface Item : NSManagedObject

@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSDate * reminder;
@property (nonatomic, retain) NSNumber * state;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Item (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

-(BOOL)isOverDue;
-(BOOL)isDueToToday;

@end
