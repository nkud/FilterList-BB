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
#import "Filter.h"
#import "Header.h"

@implementation CoreDataController

#pragma mark - アイテム用

#pragma mark - タグ用

#pragma mark - フィルター用

/**
 * @brief  選択したタグに関連したアイテムのリザルトコントローラー
 *
 * @param tags       選択するタグ
 * @param controller デリゲート
 *
 * @return リザルトコントローラー
 */
+ (NSFetchedResultsController *)itemFetchedResultsControllerForTags:(NSSet *)tags
                                                     controller:(id<NSFetchedResultsControllerDelegate>)controller
{
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  LOG(@"タグを指定したリザルトコントローラー");
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                            inManagedObjectContext:app.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  /// Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  // ソート条件
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];                // ソートを設定
  
  // 検索条件
  NSMutableArray *predicate_array = [[NSMutableArray alloc] init];  // 条件を格納する配列
  NSPredicate *predicate;                                           // 条件
  for (Tag *tag in tags) { // それぞれのタグに対して
    predicate = [NSPredicate predicateWithFormat:@"SELF == %@", tag]; // 条件を作成
    [predicate_array addObject:predicate];                          // 条件を配列に追加
  }
  // 条件の配列から条件を合成する
  NSCompoundPredicate *compound_predicate = [[NSCompoundPredicate alloc] initWithType:NSOrPredicateType
                                                                        subpredicates:predicate_array];
  [fetchRequest setPredicate:compound_predicate]; // 作成した条件を設定
  
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:app.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];   //< タグをキャッシュネームにする
  aFetchedResultsController.delegate = controller; //< デリゲートを設定
  
	/**
	 *  フェッチを実行
	 */
  LOG(@"フェッチを実行");
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return aFetchedResultsController; // 作成したリザルトコントローラーを返す
}

/**
 * @brief  フィルター用のリザルトコントローラー
 *
 * @param controller デリゲート先のコントローラー
 *
 * @return リザルトコントローラー
 */
+(NSFetchedResultsController *)filterFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller
{
  LOG(@"フィルターリザルトコントローラー");
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  // エンティティを設定
  NSEntityDescription *entity = [self entityDescriptionForName:@"Filter"];
  fetchRequest.entity = entity;

  /// Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];

  // ソート条件を設定
  LOG(@"ソート条件");
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  fetchRequest.sortDescriptors = sortDescriptors;

  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self managedObjectContext]
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];   //< タグをキャッシュネームにする
  aFetchedResultsController.delegate = controller; //< デリゲートを設定

	/**
	 *  @brief フェッチを実行
	 */
  LOG(@"フェッチを実行");
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return aFetchedResultsController; // 作成したリザルトコントローラーを返す
}

/**
 * @brief  新しいフィルターを新規挿入
 *
 * @param filterTitle   フィルターのタイトル
 * @param tagsForFilter 関連付けられたされたタグ
 */
+(void)insertNewFilter:(NSString *)filterTitle
         tagsForFilter:(NSSet *)tagsForFilter
{
  LOG(@"フィルターを新規挿入");
  Filter *newFilter = [NSEntityDescription insertNewObjectForEntityForName:@"Filter"
                                                    inManagedObjectContext:[self managedObjectContext]];
  // フィルターにタイトルを設定
  newFilter.title = filterTitle;
  
  // フィルターにタグを設定
  [newFilter addTags:tagsForFilter];

  [self saveContext];
}

/**
 *  @brief 新しいアイテムを挿入する
 *
 *  @param itemTitle タイトル
 *  @param tags      関連付けるタグのセット
 *  @param reminder  リマインダー
 */
+(void)insertNewItem:(NSString *)itemTitle
                tags:(NSSet *)tags
            reminder:(NSDate *)reminder
{
  LOG(@"アイテムを新規挿入");
  Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                             inManagedObjectContext:[self managedObjectContext]];
  newItem.title = itemTitle;
  newItem.state = [NSNumber numberWithBool:false];
  newItem.reminder = reminder;
  
  // アイテムとタグを関連付ける
  for (Tag *tag in tags) {
    [tag addItemsObject:newItem];
  }
  [newItem addTags:tags];

  /**
   *  @todo ここを関数化！！！
   */
//  for (Tag *tag in tags) {
//    NSArray *tags = [self fetchTagsForTitle:tag.title];
//    if ([tags count] > 0) {
//      Tag *tag = [tags objectAtIndex:0];
//      [tag addItemsObject:newItem];
//      [newItem addTagsObject:tag];
//    } else {
//      Tag *newTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
//                                                  inManagedObjectContext:[self managedObjectContext]];
//      newTag.title = tag.title;
//      [newTag addItemsObject:newItem];
//      [newItem addTagsObject:newTag];
//    }
//  }

  [self saveContext];
}

/**
 *  @brief 全タグの配列を返す
 *
 *  @return タグの配列
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
 *  @brief 全てのタグから、指定したタイトルのタグの配列を返す
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
 *  @brief 全アイテムのリザルトコントローラー
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

/**
 *  @brief タグのリザルトコントローラー
 *
 *  @param controller コントローラー
 *
 *  @return リザルトコントローラー
 */
+(NSFetchedResultsController *)tagFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller
{
  NSLog(@"%s", __FUNCTION__);
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  // エンティティを設定
  NSEntityDescription *entity = [self entityDescriptionForName:@"Tag"];
  fetchRequest.entity = entity;

  /// Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];

  // ソート条件を設定
  LOG(@"ソート条件");
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  fetchRequest.sortDescriptors = sortDescriptors;

  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self managedObjectContext]
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];   //< タグをキャッシュネームにする
  aFetchedResultsController.delegate = controller; //< デリゲートを設定

	/**
	 *  フェッチを実行
	 */
  LOG(@"フェッチを実行");
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return aFetchedResultsController; // 作成したリザルトコントローラーを返す
}

@end
