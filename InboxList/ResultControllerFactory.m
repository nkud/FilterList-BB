//
//  ResultControllerFactory.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/27.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ResultControllerFactory.h"
#import "AppDelegate.h"

@interface ResultControllerFactory () {

}

@end

@implementation ResultControllerFactory

/**
 *  通常のリザルトコントローラー
 *
 *  @return return value description
 */
+ (NSFetchedResultsController *)fetchedResultsController:(id<NSFetchedResultsControllerDelegate>)controller
{
  AppDelegate *app = [[UIApplication sharedApplication] delegate];

  NSLog(@"%s", __FUNCTION__);
  //  if (_fetchedResultsController != nil) {
  //    return _fetchedResultsController;
  //  }
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                            inManagedObjectContext:app.managedObjectContext];
  [fetchRequest setEntity:entity];

  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];

  // Edit the sort key as appropriate.
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];

  [fetchRequest setSortDescriptors:sortDescriptors];

  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:app.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil]; //< 元は@"Master"

  aFetchedResultsController.delegate = controller; //< デリゲートを設定

	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return aFetchedResultsController;
}

/**
 *  タグを指定したリザルトコントローラー
 *
 *  @param tagString 抽出するタグ
 *
 *  @return リザルトコントローラー
 */
+ (NSFetchedResultsController *)fetchedResultsControllerForTags:(NSSet *)tagStringSets
                                                       delegate:(id<NSFetchedResultsControllerDelegate>)controller
{
  AppDelegate *app = [[UIApplication sharedApplication] delegate];

  NSLog(@"%s", __FUNCTION__);
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                            inManagedObjectContext:app.managedObjectContext];
  [fetchRequest setEntity:entity];

  /// Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  /**
   *  ソート条件
   */
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];                 /// ソートを設定

  /**
   *  検索条件
   */
  NSMutableArray *tagStringArray;
  for (NSString *title in tagStringSets) {
    [tagStringArray addObject:title];
  }
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY SELF.tags.title == %@"
                                              argumentArray:tagStringArray];
  [fetchRequest setPredicate:predicate];

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
	NSError *error = nil;
	if (![aFetchedResultsController performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return aFetchedResultsController;
}
@end
