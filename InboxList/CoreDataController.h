//
//  CoreDataController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/09.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultControllerFactory.h"
#import "Tag.h"
#import "AppDelegate.h"

@interface CoreDataController : NSObject

+(void)saveContext;

+(BOOL)hasTagForTitle:(NSString *)title;

+(NSArray *)getAllTagsArray;
+(NSArray *)fetchTagsForTitle:(NSString *)title;

// アイテム用
+(NSFetchedResultsController *)itemFethcedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;

+(void)insertNewItem:(NSString *)itemTitle
                tags:(NSSet *)tags
            reminder:(NSDate *)reminder;

// タグ用
+(NSFetchedResultsController *)tagFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;

// フィルター用
+(NSFetchedResultsController *)filterFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;

+(void)insertNewFilter:(NSString *)filterTitle
         tagsForFilter:(NSSet *)tagsForFilter;

+(NSEntityDescription *)entityDescriptionForName:(NSString *)name;

+(NSManagedObjectContext *)managedObjectContext;
+(AppDelegate *)app;
@end
