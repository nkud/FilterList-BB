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

+(void)insertNewItem:(NSString *)itemTitle tags:(NSSet *)tags reminder:(NSDate *)reminder;

+(NSFetchedResultsController *)itemFethcedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;
+(NSFetchedResultsController *)tagFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;

+(NSEntityDescription *)entityDescriptionForName:(NSString *)name;

+(NSManagedObjectContext *)managedObjectContext;
+(AppDelegate *)app;
@end
