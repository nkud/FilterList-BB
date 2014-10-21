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
 * @brief  コアデータコントローラー
 */
@interface CoreDataController : NSObject

+(void)saveContext;

+(BOOL)hasTagForTitle:(NSString *)title;

// アイテム用
+(NSFetchedResultsController *)itemFethcedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;
+(NSFetchedResultsController *)itemFetchedResultsControllerForTags:(NSSet *)tags
                                                        controller:(id<NSFetchedResultsControllerDelegate>)controller;
+(void)insertNewItem:(NSString *)itemTitle
                 tag:(Tag *)tag
            reminder:(NSDate *)reminder;
+(Item *)newItemObject;
+(NSInteger)countItems;

// タグ用
+(NSFetchedResultsController *)tagFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;
+(NSFetchedResultsController *)userTagFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;
+(NSArray *)getAllTagsArray;
+(NSArray *)fetchTagsForTitle:(NSString *)title;
+(Tag *)newTagObject;

+(void)insertNewTag:(NSString *)title;

// フィルター用
+(NSFetchedResultsController *)filterFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;
+(void)insertNewFilter:(NSString *)filterTitle
         tagsForFilter:(NSSet *)tagsForFilter;
+(Filter *)newFilterObject;

#pragma mark - 完了リスト用
+(NSFetchedResultsController *)completeFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;

// その他
+(NSEntityDescription *)entityDescriptionForName:(NSString *)name;

+(NSManagedObjectContext *)managedObjectContext;
+(AppDelegate *)app;
@end
