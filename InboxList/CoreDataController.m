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
#import "Header.h"

@implementation CoreDataController

/**
 *  新しいアイテムを挿入する
 *
 *  @param itemTitle タイトル
 *  @param tags      関連付けるタグのセット
 *  @param reminder  リマインダー
 */
+(void)insertNewItem:(NSString *)itemTitle
                tags:(NSSet *)tags
            reminder:(NSDate *)reminder
{
  NSLog(@"%s", __FUNCTION__);
  Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                             inManagedObjectContext:[self managedObjectContext]];
  newItem.title = itemTitle;
  newItem.state = [NSNumber numberWithBool:false];
  newItem.reminder = reminder;

  for (Tag *tag in tags) {
    NSArray *tags = [self fetchTagsForTitle:tag.title];
    if ([tags count] > 0) {
      Tag *tag = [tags objectAtIndex:0];
      [tag addItemsObject:newItem];
      [newItem addTagsObject:tag];
      LOG(@"%d", tag.items.count);
    } else {
      Tag *newTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                                  inManagedObjectContext:[self managedObjectContext]];
      newTag.title = tag.title;
      [newTag addItemsObject:newItem];
      [newItem addTagsObject:newTag];
    }
  }

  [self saveContext];
}

/**
 *  全タグの配列を返す
 *
 *  @return <#return value description#>
 *  @todo ソート条件までは設定していない
 */
+(NSArray *)getAllTagsArray
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init]; // リクエスト
  NSEntityDescription *entity = [self entityDescriptionForName:@"Tag"]; // エンティティディスクリプションを取得
  request.entity = entity; // エンティティディスクリプションをリクエストに設定

  NSArray *tags_array = [[self managedObjectContext] executeFetchRequest:request
                                                                   error:nil];
  
  return tags_array;
}
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
+(BOOL)hasTagForTitle:(NSString *)title
{
  NSInteger num = [[self getAllTagsArray] count];
  if (num > 0) {                // それが０より大きければ
    return YES;                 // 真を返し
  } else {                      // そうでなければ
    return NO;                  // 偽を返す
  }
}

/**
 *  全てのタグから、指定したタイトルのタグの配列を返す
 *
 *  @param title 指定するタイトル
 *
 *  @return タグの配列
 */
+(NSArray *)fetchTagsForTitle:(NSString *)title
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init]; // リクエスト

  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title == %@", title];
  NSEntityDescription *entity = [self entityDescriptionForName:@"Tag"]; // エンティティディスクリプションを取得
  request.predicate = predicate;
  request.entity = entity; // エンティティディスクリプションをリクエストに設定

  NSArray *tags_array = [[self managedObjectContext] executeFetchRequest:request
                                                                   error:nil];
  return tags_array;
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
