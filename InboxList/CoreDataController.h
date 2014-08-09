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

@interface CoreDataController : NSObject

+(void)saveContext;

+(BOOL)hasTag:(Tag *)tag;

+(NSArray *)getAllTagsArray;

+(NSFetchedResultsController *)itemFethcedResultsController:(id<NSFetchedResultsControllerDelegate>)controller;

@end
