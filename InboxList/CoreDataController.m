//
//  CoreDataController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/09.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "CoreDataController.h"
#import "ResultControllerFactory.h"
#import "AppDelegate.h"

@implementation CoreDataController
/**
 *  エンティティディスクリプションを返す
 *
 *  @param name エンティティ名
 *
 *  @return エンティティディスクリプション
 */
+(NSEntityDescription *)entityDescriptionForName:(NSString *)name
{
  return [NSEntityDescription entityForName:name
                     inManagedObjectContext:[self app].managedObjectContext];
}

/**
 *  アプリケーションデリゲート
 *
 *  @return <#return value description#>
 */
+(AppDelegate *)app
{
  AppDelegate *ret = [[UIApplication sharedApplication] delegate];
  return ret;
}

/**
 *  コンテキストを保存する
 */
+(void)saveContext
{
  [[self app] saveContext];
}

+(NSManagedObjectContext *)managedObjectContext
{
  return [self app].managedObjectContext;
}

/**
 *  タグが既存かどうか
 *
 *  @param tag 調べるタグ
 *
 *  @return 真偽値
 */
+(BOOL)hasTag:(Tag *)tag
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [self entityDescriptionForName:@"Tag"];
  request.entity = entity;
  NSUInteger num = [[self managedObjectContext] countForFetchRequest:request
                                                                error:nil];
  if (num > 0) {
    return YES;
  } else {
    return NO;
  }
}

/**
 *  全アイテムのリザルトコントローラー
 *
 *  @param controller デリゲート先
 *
 *  @return リザルトコントローラー
 */
+(NSFetchedResultsController *)itemFethcedResultsController:(id<NSFetchedResultsControllerDelegate>)controller
{
  NSFetchedResultsController *ret = [ResultControllerFactory fetchedResultsController:controller];
  return ret;
}

@end