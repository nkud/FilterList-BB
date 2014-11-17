//
//  CoreDataController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/09.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "CoreDataController.h"
#import "AppDelegate.h"
#import "Filter.h"
#import "Header.h"

enum __SECTION__ {
  __MENU_SECTION__ = 0,
  __TAG_SECTTION__ = 1
};

#pragma mark -

@interface CoreDataController () {
  int fetch_batch_size_;
}
//+(void)addTagObjecForAllItems;

@end

@implementation CoreDataController

#pragma mark - アイテム用
/**
 *  @brief 全アイテムのリザルトコントローラー
 *
 *  @param controller デリゲート先
 *
 *  @return リザルトコントローラー
 */
+(NSFetchedResultsController *)itemFethcedResultsController:(id<NSFetchedResultsControllerDelegate>)controller
{
  // アプリケーションデリゲートを取得
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  static NSString *item_entity_name = @"Item";
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:item_entity_name
                                            inManagedObjectContext:app.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  
  // ソート設定
  // (タグのタイトル)でソート
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag.title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  // 検索条件
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"0 == SELF.state.intValue"];
  
  [fetchRequest setPredicate:predicate]; // 作成した条件を設定
  
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:app.managedObjectContext
                                          sectionNameKeyPath:@"tagName"
                                                   cacheName:nil]; //< 元は@"Master"
  
  aFetchedResultsController.delegate = controller; //< デリゲートを設定
  
	NSError *error = nil;
  LOG(@"フェッチを実行");
	if (![aFetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return aFetchedResultsController; // 作成したリザルトコントローラーを返す
}

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
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag.title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  // 検索条件
  // 指定されたタグ名で抽出
  NSMutableArray *predicate_array = [[NSMutableArray alloc] init];
  NSPredicate *predicate;
  for (Tag *tag in tags) {
    predicate = [NSPredicate predicateWithFormat:@"%@ == SELF.tag.title", tag.title];
    [predicate_array addObject:predicate];
  }
  // 未完了のアイテムを抽出
  predicate = [NSPredicate predicateWithFormat:@"%@ == SELF.state", [NSNumber numberWithBool:false]];

  // 条件の配列から条件を合成する
  NSCompoundPredicate *tag_predicates
  = [[NSCompoundPredicate alloc] initWithType:NSOrPredicateType
                                subpredicates:predicate_array];
  NSCompoundPredicate *compound_predicate
  = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                subpredicates:@[tag_predicates, predicate]];
  [fetchRequest setPredicate:compound_predicate];
  
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:app.managedObjectContext
                                          sectionNameKeyPath:@"tagName"
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
 *  @brief 新しいアイテムを挿入する
 *
 *  @param itemTitle タイトル
 *  @param tags      関連付けるタグのセット
 *  @param reminder  リマインダー
 */
+(void)insertNewItem:(NSString *)itemTitle
                 tag:(Tag *)tag
            reminder:(NSDate *)reminder
{
  LOG(@"アイテムを新規挿入");
  // アイテムを作成
  Item *newItem = [self newItemObject];
  
  // タイトルを設定
  newItem.title = itemTitle;
  // 状態を設定
  newItem.state = [NSNumber numberWithBool:false];
  // リマインダーを設定
  newItem.reminder = reminder;
  // アイテムとタグを関連付ける
  if (tag) {
    newItem.tag = tag;
  } else {
    
  }

  [self saveContext];
}

/**
 * @brief  空のタグ
 *
 * @return インスタンス
 */
+(Tag *)emptyTag
{
  Tag *tag = [self newTagObject];
  return tag;
}

/**
 * @brief  新しいアイテムを作成
 *
 * @return アイテムのポインタ
 */
+(Item *)newItemObject
{
  return [NSEntityDescription insertNewObjectForEntityForName:@"Item"
                                       inManagedObjectContext:[self app].managedObjectContext];
}

+(NSInteger)countItems
{
  NSInteger ret;
  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
  NSArray *array = [[CoreDataController managedObjectContext] executeFetchRequest:request
                                                                            error:nil];
  ret = [array count];
  return ret;
}

#pragma mark - タグ用

/**
 *  @brief タグのリザルトコントローラー
 *
 *  @param controller コントローラー
 *
 *  @return リザルトコントローラー
 */
+(NSFetchedResultsController *)tagFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller
{
  LOG(@"タグ用のリザルトコントローラー");
  
//  [self addTagObjecForAllItems];
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  
  // エンティティを設定
  static NSString *tag_entity_name = @"Tag";
  NSEntityDescription *entity = [self entityDescriptionForName:tag_entity_name];
  fetchRequest.entity = entity;
  
  /// Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  
  // ソート条件を設定
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order"
                                                                 ascending:YES];
  NSArray *sortDescriptors = @[sortDescriptor];
  fetchRequest.sortDescriptors = sortDescriptors;

  // コントローラーを作成
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self managedObjectContext]
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
  // デリゲートを設定
  aFetchedResultsController.delegate = controller;
  
	/**
	 *  フェッチを実行
	 */
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return aFetchedResultsController;
}

+(NSFetchedResultsController *)tagFetchedResultsControllerWithSearch:(NSString *)searchString
                                                            delegate:(id<NSFetchedResultsControllerDelegate>)controller
{
  LOG(@"タグ用のリザルトコントローラー");
  
  //  [self addTagObjecForAllItems];
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  
  // エンティティを設定
  static NSString *tag_entity_name = @"Tag";
  NSEntityDescription *entity = [self entityDescriptionForName:tag_entity_name];
  fetchRequest.entity = entity;
  
  /// Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  
  // ソート条件を設定
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                 ascending:YES];
  NSArray *sortDescriptors = @[sortDescriptor];
  fetchRequest.sortDescriptors = sortDescriptors;
  
  // 検索文字列
  NSPredicate *filterPredicate;
  NSMutableArray *predicateArray = [NSMutableArray array];
  if (searchString.length) {
    // your search predicate(s) are added to this array
    [predicateArray addObject:[NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchString]];
    // finally add the filter predicate for this view
    filterPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicateArray];
  }
  [fetchRequest setPredicate:filterPredicate];
  
  // コントローラーを作成
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[self managedObjectContext]
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];
  // デリゲートを設定
  aFetchedResultsController.delegate = controller;
  
  /**
   *  フェッチを実行
   */
  NSError *error = nil;
  if (![aFetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  return aFetchedResultsController;
}
/**
 * @brief  ユーザー定義タグのみのリザルトコントローラー
 *
 * @param controller コントローラ
 *
 * @return リザルトコントローラー
 */
//+(NSFetchedResultsController *)userTagFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller
//{
//  LOG(@"タグ用のリザルトコントローラー");
//  
////  [self addTagObjecForAllItems];
//  
//  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//  
//  // エンティティを設定
//  static NSString *tag_entity_name = @"Tag";
//  NSEntityDescription *entity = [self entityDescriptionForName:tag_entity_name];
//  fetchRequest.entity = entity;
//  
//  /// Set the batch size to a suitable number.
//  [fetchRequest setFetchBatchSize:20];
//  
//  // ソート条件を設定
//  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
//                                                                 ascending:YES];
//  NSArray *sortDescriptors = @[sortDescriptor];
//  [fetchRequest setSortDescriptors:sortDescriptors];
//  
//  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.section == %d", __TAG_SECTTION__];
//  [fetchRequest setPredicate:predicate];
//  
//  // コントローラーを作成
//  NSFetchedResultsController *aFetchedResultsController
//  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
//                                        managedObjectContext:[self managedObjectContext]
//                                          sectionNameKeyPath:nil
//                                                   cacheName:nil];
//  // デリゲートを設定
//  aFetchedResultsController.delegate = controller;
//  
//  // フェッチを実行
//	NSError *error = nil;
//	if (![aFetchedResultsController performFetch:&error]) {
//    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//    abort();
//	}
//  return aFetchedResultsController;
//}

/**
 * @brief  タグを挿入
 *
 * @param title タイトル
 */
+(void)insertNewTag:(NSString *)title
{
  Tag *tag = [self newTagObject];
  tag.title = title;
  tag.order = [NSNumber numberWithInteger:[CoreDataController lastTagOrder] + 1];
  tag.section = [NSNumber numberWithInt:__TAG_SECTTION__];
  [self saveContext];
  LOG(@"[ new tag ] title=%@, order=%@", tag.title, tag.order);
}

+ (NSInteger)lastTagOrder
{
  NSInteger order = 0;
  
  NSArray *tags =  [[CoreDataController tagFetchedResultsController:nil] fetchedObjects];
  if (tags.count > 0) {
    Tag *lastTag = [tags lastObject];
    order = [lastTag.order integerValue];
  }
  return order;
}

/**
 *  @brief 全タグの配列を返す
 *
 *  @return タグの配列
 *  @todo ソート条件までは設定していない
 */
+(NSArray *)getAllTagsArray
{
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [self entityDescriptionForName:@"Tag"];
  request.entity = entity;

  NSArray *tags_array = [[self managedObjectContext] executeFetchRequest:request
                                                                   error:nil];
  
  return tags_array;
}


/**
 * @brief  新しいタグを作成
 
 * @return タグのポインタ
 */
+(Tag *)newTagObject
{
  Tag* tag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                           inManagedObjectContext:[self app].managedObjectContext];
  return tag;
}

/**
 *  @brief タグが既存かどうか
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
  NSEntityDescription *entity = [self entityDescriptionForName:@"Tag"];
  request.predicate = predicate;
  request.entity = entity;
  
  NSArray *tags_array = [[self managedObjectContext] executeFetchRequest:request
                                                                   error:nil];
  return tags_array;
}

#pragma mark - フィルター用

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

  // フェッチを実行
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
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

+(Filter *)newFilterObject
{
  Filter* filter = [NSEntityDescription insertNewObjectForEntityForName:@"Filter"
                                                 inManagedObjectContext:[self app].managedObjectContext];
  return filter;
}

#pragma mark - 完了リスト

+(NSFetchedResultsController *)completeFetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller
{
  // アプリケーションデリゲートを取得
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  static NSString *item_entity_name = @"Item";
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:item_entity_name
                                            inManagedObjectContext:app.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  
  // ソート設定
  // (タグのタイトル)でソート
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"completionDate"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  // 検索条件
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ == SELF.state", [NSNumber numberWithBool:true]];
  
  [fetchRequest setPredicate:predicate]; // 作成した条件を設定
  
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:app.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil]; //< 元は@"Master"
  
  aFetchedResultsController.delegate = controller; //< デリゲートを設定
  
  NSError *error = nil;
  LOG(@"フェッチを実行");
  if (![aFetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  return aFetchedResultsController; // 作成したリザルトコントローラーを返す
}

#pragma mark - エンティティ

/**
 *  @brief エンティティディスクリプションを返す
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

#pragma mark - ゲッター

/**
 *  @brief アプリケーションデリゲート
 *
 *  @return <#return value description#>
 */
+(AppDelegate *)app
{
  AppDelegate *ret = [[UIApplication sharedApplication] delegate];
  return ret;
}

/**
 *  @brief コンテキストを保存する
 */
+(void)saveContext
{
  [[self app] saveContext];
}

/**
 * @brief  管理オブジェクトコンテキストを取得
 *
 * @return 管理オブジェクトコンテキスト
 */
+(NSManagedObjectContext *)managedObjectContext
{
  return [self app].managedObjectContext;
}



@end
