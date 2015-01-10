//
//  CoreDataController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/09.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tag.h"
#import "AppDelegate.h"

/**
 * @brief  コントローラー
 */
@interface CoreDataController : NSObject

+(void)saveContext;

+(BOOL)hasTagForTitle:(NSString *)title;

#pragma mark - アイテム用
+(NSFetchedResultsController *)itemFethcedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;
+(NSFetchedResultsController *)itemFetchedResultsControllerForTags:(NSSet *)tags
                                                        controller:(id<NSFetchedResultsControllerDelegate>)controller;
+ (NSFetchedResultsController *)itemFetchedResultsControllerForTags:(NSSet *)tags
                                                      filterOverdue:(BOOL)filterOverdue
                                                        filterToday:(BOOL)filterToday
                                                       filterFuture:(BOOL)filterFuture
                                                         controller:(id<NSFetchedResultsControllerDelegate>)controller;
+ (NSFetchedResultsController *)itemFetchedResultsControllerWithFilter:(Filter *)filter
                                                            controller:(id<NSFetchedResultsControllerDelegate>)controller;

+(void)insertNewItem:(NSString *)itemTitle
                 tag:(Tag *)tag
            reminder:(NSDate *)reminder;
+(Item *)newItemObject;
+(NSInteger)countItems;
+(NSInteger)countUncompletedItems;
+(NSInteger)countUncompletedItemsWithTags:(NSSet *)tags;

#pragma mark - タグ用
+(NSFetchedResultsController *)tagFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;
+(NSFetchedResultsController *)tagFetchedResultsControllerWithSearch:(NSString *)searchString
                                                            delegate:(id<NSFetchedResultsControllerDelegate>)controller;

+(NSArray *)getAllTagsArray;
+(NSArray *)fetchTagsForTitle:(NSString *)title;
+(Tag *)newTagObject;
+(void)refleshTagsOrder;

+(void)insertNewTag:(NSString *)title;

#pragma mark - フィルター用
+(NSFetchedResultsController *)filterFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;
+(void)insertNewFilter:(NSString *)filterTitle
         tagsForFilter:(NSSet *)tagsForFilter;
+(Filter *)newFilterObject;

#pragma mark - 完了リスト用
+(NSFetchedResultsController *)completeFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;

#pragma mark - その他
+(NSEntityDescription *)entityDescriptionForName:(NSString *)name;

+(NSManagedObjectContext *)managedObjectContext;
+(AppDelegate *)app;
@end
