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
  // (タグのタイトル)でソートする
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag.order"
                                                                 ascending:YES];
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
  
  LOG(@"デリゲートを設定する");
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
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                            inManagedObjectContext:app.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  
  // タグのタイトルで、アイテムをソートする
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag.title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  // 指定されたタグ名で、
  // 未完了のアイテムを抽出する
  NSMutableArray *predicate_array = [[NSMutableArray alloc] init];
  NSPredicate *predicate;
  for (Tag *tag in tags) {
    predicate = [NSPredicate predicateWithFormat:@"%@ == SELF.tag.title", tag.title];
    [predicate_array addObject:predicate];
  }
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
  
  
  // フェッチを実行して、
  // 作成したコントローラーを返す
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return aFetchedResultsController;
}

+ (NSFetchedResultsController *)itemFetchedResultsControllerWithFilter:(Filter *)filter
                                                           controller:(id<NSFetchedResultsControllerDelegate>)controller
{
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                            inManagedObjectContext:app.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  
  // タグのタイトルで、アイテムをソートする
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag.title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];
  
  NSPredicate *predicate;
  predicate = [NSPredicate predicateWithFormat:@"%@ == SELF.state", [NSNumber numberWithBool:false]];
  
  NSMutableArray *due_predicate_array = [[NSMutableArray alloc] init];
  
  // 指定された期限で抽出する。
  // 今日かつ期限超過の時は、論理和で抽出する。
  if (filter.overdue) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|
                                    NSMonthCalendarUnit|
                                    NSDayCalendarUnit|
                                    NSHourCalendarUnit|
                                    NSMinuteCalendarUnit
                                               fromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSDate *startDate = [formatter dateFromString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld-00-00",
                                                   (long)components.year,
                                                   (long)components.month,
                                                   (long)components.day]];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF.reminder < %@", startDate];
    [due_predicate_array addObject:pre];
  }
  if (filter.future) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|
                                    NSMonthCalendarUnit|
                                    NSDayCalendarUnit|
                                    NSHourCalendarUnit|
                                    NSMinuteCalendarUnit
                                               fromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSDate *endDate = [formatter dateFromString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld-00-00",
                                                 (long)components.year,
                                                 (long)components.month,
                                                 (long)components.day+1]];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF.reminder > %@", endDate];
    [due_predicate_array addObject:pre];
  }
  if (filter.today) {
    // 今日までの場合、
    // 今日の日付の午前０時から、
    // 明日の日付の午前０時までの
    // ２４時間で抽出する。
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|
                                    NSMonthCalendarUnit|
                                    NSDayCalendarUnit|
                                    NSHourCalendarUnit|
                                    NSMinuteCalendarUnit
                                               fromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSDate *startDate = [formatter dateFromString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld-00-00",
                                                   (long)components.year,
                                                   (long)components.month,
                                                   (long)components.day]];
    NSDate *endDate = [formatter dateFromString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld-00-00",
                                                 (long)components.year,
                                                 (long)components.month,
                                                 (long)components.day+1]];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"(%@ <= SELF.reminder) AND (SELF.reminder <= %@)", startDate, endDate];
    [due_predicate_array addObject:pre];
  }
  NSCompoundPredicate *due_predicates
  =[[NSCompoundPredicate alloc] initWithType:NSOrPredicateType
                               subpredicates:due_predicate_array];
  
  // 条件の配列から条件を合成する
    NSCompoundPredicate *compound_predicate
  = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                subpredicates:@[predicate, due_predicates]];
  [fetchRequest setPredicate:compound_predicate];
  
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:app.managedObjectContext
                                          sectionNameKeyPath:@"tagName"
                                                   cacheName:nil];   //< タグをキャッシュネームにする
  aFetchedResultsController.delegate = controller; //< デリゲートを設定
  
  
  // フェッチを実行して、
  // 作成したコントローラーを返す
  NSError *error = nil;
  if (![aFetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  return aFetchedResultsController;
}

+ (NSFetchedResultsController *)itemFetchedResultsControllerForTags:(NSSet *)tags
                                                      filterOverdue:(BOOL)filterOverdue
                                                        filterToday:(BOOL)filterToday
                                                       filterFuture:(BOOL)filterFuture
                                                         controller:(id<NSFetchedResultsControllerDelegate>)controller
{
  AppDelegate *app = [[UIApplication sharedApplication] delegate];
  
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                            inManagedObjectContext:app.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  
  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  
  // タグのタイトルで、アイテムをソートする
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tag.title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];

  // 指定されたタグ名で、
  // 未完了のアイテムを抽出する
  NSMutableArray *predicate_array = [[NSMutableArray alloc] init];
  NSPredicate *predicate;
  for (Tag *tag in tags) {
    predicate = [NSPredicate predicateWithFormat:@"%@ == SELF.tag.title", tag.title];
    [predicate_array addObject:predicate];
  }
  predicate = [NSPredicate predicateWithFormat:@"%@ == SELF.state", [NSNumber numberWithBool:false]];
  
  NSMutableArray *due_predicate_array = [[NSMutableArray alloc] init];
  
  // 指定された期限で抽出する。
  // 今日かつ期限超過の時は、論理和で抽出する。
  if (filterOverdue) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|
                                    NSMonthCalendarUnit|
                                    NSDayCalendarUnit|
                                    NSHourCalendarUnit|
                                    NSMinuteCalendarUnit
                                               fromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSDate *startDate = [formatter dateFromString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld-00-00",
                                                 (long)components.year,
                                                 (long)components.month,
                                                 (long)components.day]];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF.reminder < %@", startDate];
    [due_predicate_array addObject:pre];
  }
  if (filterFuture) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|
                                    NSMonthCalendarUnit|
                                    NSDayCalendarUnit|
                                    NSHourCalendarUnit|
                                    NSMinuteCalendarUnit
                                               fromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSDate *endDate = [formatter dateFromString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld-00-00",
                                                 (long)components.year,
                                                 (long)components.month,
                                                 (long)components.day+1]];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF.reminder > %@", endDate];
    [due_predicate_array addObject:pre];
  }
  if (filterToday) {
    // 今日までの場合、
    // 今日の日付の午前０時から、
    // 明日の日付の午前０時までの
    // ２４時間で抽出する。
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|
                                    NSMonthCalendarUnit|
                                    NSDayCalendarUnit|
                                    NSHourCalendarUnit|
                                    NSMinuteCalendarUnit
                                               fromDate:[NSDate date]];
    [formatter setDateFormat:@"yyyy-MM-dd-HH-mm"];
    NSDate *startDate = [formatter dateFromString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld-00-00",
                                                   (long)components.year,
                                                   (long)components.month,
                                                   (long)components.day]];
    NSDate *endDate = [formatter dateFromString:[NSString stringWithFormat:@"%04ld-%02ld-%02ld-00-00",
                                                 (long)components.year,
                                                 (long)components.month,
                                                 (long)components.day+1]];
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"(%@ <= SELF.reminder) AND (SELF.reminder <= %@)", startDate, endDate];
    [due_predicate_array addObject:pre];
  }
  NSCompoundPredicate *due_predicates
  =[[NSCompoundPredicate alloc] initWithType:NSOrPredicateType
                               subpredicates:due_predicate_array];
  
  // 条件の配列から条件を合成する
  NSCompoundPredicate *tag_predicates
  = [[NSCompoundPredicate alloc] initWithType:NSOrPredicateType
                                subpredicates:predicate_array];
  NSCompoundPredicate *compound_predicate
  = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                subpredicates:@[tag_predicates, predicate, due_predicates]];
  [fetchRequest setPredicate:compound_predicate];
  
  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:app.managedObjectContext
                                          sectionNameKeyPath:@"tagName"
                                                   cacheName:nil];   //< タグをキャッシュネームにする
  aFetchedResultsController.delegate = controller; //< デリゲートを設定
  
  
  // フェッチを実行して、
  // 作成したコントローラーを返す
  NSError *error = nil;
  if (![aFetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  return aFetchedResultsController;
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
  // アイテムを作成
  LOG(@"アイテムを作成する");
  Item *newItem = [self newItemObject];
  
  // タイトルを設定
  newItem.title = itemTitle;
  // 状態を設定
  newItem.state = [NSNumber numberWithBool:false];
  // リマインダーを設定
  newItem.reminder = reminder;
  // アイテムとタグを関連付ける
  LOG(@"アイテムとタグを関連付ける");
  if (tag) {
    newItem.tag = tag;
  } else {
    
  }
  LOG(@"作成したアイテムを保存する");
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

/**
 * @brief  アイテム数を返す
 *
 * @return アイテム数
 */
+(NSInteger)countItems
{
  NSInteger ret;
  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
  NSArray *array = [[CoreDataController managedObjectContext] executeFetchRequest:request
                                                                            error:nil];
  ret = [array count];
  return ret;
}

/**
 * @brief  未完了のアイテム数を数える
 *
 * @return 未完了のアイテム数
 */
+(NSInteger)countUncompletedItems
{
  NSInteger ret;
  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ == SELF.state", [NSNumber numberWithBool:false]];
  [request setPredicate:predicate];

  NSArray *array = [[CoreDataController managedObjectContext] executeFetchRequest:request
                                                                            error:nil];
  ret = [array count];
  return ret;
}

+(NSInteger)countUncompletedItemsWithTags:(NSSet *)tags
{
  NSInteger ret;
  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Item"];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ == SELF.state", [NSNumber numberWithBool:false]];
  
  NSMutableArray *predicate_array = [[NSMutableArray alloc] init];
  NSPredicate *tag_predicates;
  for (Tag *tag in tags) {
    if (tag.title) {
      tag_predicates = [NSPredicate predicateWithFormat:@"%@ == SELF.tag.title", tag.title];
      [predicate_array addObject:predicate];
    }
  }
  NSArray *predicatesArray;
  if (tag_predicates) {
    predicatesArray = @[tag_predicates, predicate];
  } else {
    predicatesArray = @[predicate];
  }
  NSCompoundPredicate *compound_predicate
  = [[NSCompoundPredicate alloc] initWithType:NSAndPredicateType
                                subpredicates:predicatesArray];
  
  [request setPredicate:compound_predicate];
  
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
  LOG(@"タグフェッチコントローラが呼び出される");
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

  // フェッチを実行する
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
 * @brief  タグを挿入
 *
 * @param title タイトル
 */
+(void)insertNewTag:(NSString *)title
{
  // 既存のタグ順序を１つずらす
  [CoreDataController incrementTagOrder];
  
  Tag *tag = [self newTagObject];
  tag.title = title;
  tag.order = [NSNumber numberWithInteger:0];
  tag.section = [NSNumber numberWithInt:__TAG_SECTTION__];
  [self saveContext];
  LOG(@"[ new tag ] title=%@, order=%@", tag.title, tag.order);
}

+(void)incrementTagOrder
{
  NSArray *tags = [[CoreDataController tagFetchedResultsController:nil] fetchedObjects];
  for (Tag *tag in tags) {
    NSNumber *originOrder = [tag valueForKey:@"order"];
    NSInteger newOrder = [originOrder integerValue] + 1;
    tag.order = [NSNumber numberWithInteger:newOrder];
  }
  [CoreDataController saveContext];
}

/**
 * @brief  タグの順序をリフレッシュする
 */
+(void)refleshTagsOrder
{
  LOG(@"タグの順序をリフレッシュ");
  NSArray *tags = [[CoreDataController tagFetchedResultsController:nil] fetchedObjects];
  int order = 0;
  for (Tag *tag in tags) {
    tag.order = [NSNumber numberWithInteger:order];
    order++;
  }
  [CoreDataController saveContext];
}

//+ (NSInteger)lastTagOrder
//{
//  NSInteger order = 0;
//  
//  NSArray *tags =  [[CoreDataController tagFetchedResultsController:nil] fetchedObjects];
//  if (tags.count > 0) {
//    Tag *lastTag = [tags lastObject];
//    order = [lastTag.order integerValue];
//  }
//  return order;
//}

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
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

  // エンティティを設定
  static NSString *tag_entity_name = @"Filter";
  NSEntityDescription *entity = [self entityDescriptionForName:tag_entity_name];
  fetchRequest.entity = entity;

  /// Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];

  // ソート条件を設定
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order"
                                                                 ascending:YES];
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
  [CoreDataController incrementFilterOrder];
  LOG(@"フィルターを新規挿入");
  Filter *newFilter = [NSEntityDescription insertNewObjectForEntityForName:@"Filter"
                                                    inManagedObjectContext:[self managedObjectContext]];
  // フィルターにタイトルを設定
  newFilter.title = filterTitle;
  newFilter.order = [NSNumber numberWithInt:0];
  
  // フィルターにタグを設定
  // addTagsでは警告が出る
//  [newFilter addTags:tagsForFilter];
  for (Tag *tag in tagsForFilter) {
    [newFilter addTagsObject:tag];
  }

  [self saveContext];
}
+(void)incrementFilterOrder
{
  NSArray *filters = [[CoreDataController filterFetchedResultsController:nil] fetchedObjects];
  for (Filter *filter in filters) {
    NSNumber *originOrder = [filter valueForKey:@"order"];
    NSInteger newOrder = [originOrder integerValue] + 1;
    filter.order = [NSNumber numberWithInteger:newOrder];
  }
  [CoreDataController saveContext];
}

+(Filter *)newFilterObject
{
  Filter* filter = [NSEntityDescription insertNewObjectForEntityForName:@"Filter"
                                                 inManagedObjectContext:[self app].managedObjectContext];
  [self incrementFilterOrder];
  filter.order = [NSNumber numberWithInt:0];
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
 *  @return アプリケーション
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
  LOG(@"コンテキストに保存開始");
  [[self app] saveContext];
  LOG(@"コンテキストへの保存終了");
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
