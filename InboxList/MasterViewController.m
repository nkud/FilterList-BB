//
//  MasterViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "InputModalViewController.h"
#import "Tag.h"
#import "Item.h"
#import "Cell.h"
#import "Header.h"

@interface MasterViewController () {
  int location_center_x;
  BOOL isOpen;
}

- (void)configureCell:(Cell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation MasterViewController

/**
 * 存在するタグのリストを取得する
 *
 * @note NSMutableArrayを返してもいいのか？あと、このクラスが持つべきではないかも
 */
-(NSArray *)getTagList
{
  NSLog(@"%s", __FUNCTION__);
  NSMutableArray *taglist = [[NSMutableArray alloc] init];           //< 返す配列
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag"
                                            inManagedObjectContext:self.managedObjectContext];
  request.entity = entity;
  request.sortDescriptors = nil;                                     //< @TODO メニューをソートする場合はここ
  NSArray *objs = [self.managedObjectContext executeFetchRequest:request
                                                           error:nil];
  for ( Tag *tag in objs ) {
    /// @todo タグ関連は要変更
    if ([tag.title isEqual:@""]) continue;                           //< タイトルが未設定ならスキップ
    if ([tag.items count]==0) continue;                              //< アイテムに紐付けされていなければスキップ

    [taglist addObject:tag.title];
  }
  return taglist;
}

/**
 * @brief セルのチェックボックスがタッチされた時の処理
 */
-(void)tappedCheckBox:(Cell *)cell
                touch:(UITouch *)touch
{
  /// 位置を取得して
  CGPoint tappedPoint = [touch locationInView:self.view];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tappedPoint];

  /// その位置のセルのデータをモデルから取得する
  Item *item = [[self fetchedResultsControllerForSelectedTag] objectAtIndexPath:indexPath];

  /// チェックの状態を変更して
  BOOL checkbox = ! [[item valueForKey:@"state"] boolValue];
  item.state = [NSNumber numberWithBool:checkbox];

  /// チェックボックスを更新する
  [cell updateCheckBox:checkbox];

  /// モデルを保存する
  NSError *error = nil;
  if (![self.managedObjectContext save:&error]) {
    NSLog(@"error = %@", error);
  } else {
    NSLog(@"Update Completed.");
  }
}
/**
 * パラメータを初期化する
 */
- (void)initParameter
{
  isOpen = false;
  self.selectedTagString = nil;
}

/**
 * 初期化する
 */
- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];

  if (self) {
    self.title = @"master";
  }

  return self;
}


/**
 * ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  NSLog(@"%s", __FUNCTION__);
  [super viewDidLoad];

  /// 変数を初期化
  [self initParameter];

  /// セルとして使うクラスを登録する
  [self.tableView registerClass:[Cell class] forCellReuseIdentifier:@"Cell"];
  [self.tableView setRowHeight:50];

  /// 編集ボタン
  UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self action:@selector(toEdit:)];
  self.navigationItem.leftBarButtonItem = editButton;

  /// 新規ボタン
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(inputAndInsertNewObjectFromModalView)];
  self.navigationItem.rightBarButtonItem = addButton;
}

/**
 * 編集モードの切り替え
 */
- (void)toEdit:(id)sender
{
  NSLog(@"%s", __FUNCTION__);
  if (self.tableView.isEditing) {
    [self setEditing:false animated:YES];
  } else {
    [self setEditing:true animated:YES];
  }
}


/**
 * 入力画面を終了させる。フィールドの値を受け取る。
 */
- (void)dismissInputModalView:(id)sender
                         data:(NSArray *)data
{
  NSLog(@"%s", __FUNCTION__);
  NSString *title = data[0];                                         //< タイトルを取得して
  if (title.length > 0) {                                            //< 空欄でなければ
    [self insertNewObject:sender data:data];                         //< リストを挿入する
  }

  [self dismissViewControllerAnimated:YES completion:nil];           //< ビューを削除
}

/**
 * @brief 詳細ビューを削除する前の処理
 * @todo 複数のタグに対応させる。インプットビューでも
 */
-(void)dismissDetailView:(id)sender
                   index:(NSIndexPath *)indexPath
               itemTitle:(NSString *)itemTitle
               tagTitles:(NSArray *)tagTitles
{
  NSLog(@"%s", __FUNCTION__);
  /// アイテムを取得
  Item *item = [[self fetchedResultsControllerForSelectedTag] objectAtIndexPath:indexPath];

  [item setValue:itemTitle forKeyPath:@"title"]; //< 更新後のタイトルを代入
  /// 更新後のタグを代入
  /// ここでは空白区切りで羅列している
  NSMutableSet *tags = [[NSMutableSet alloc] init];
  for( NSString *title in tagTitles ) {
    Tag *newTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                                inManagedObjectContext:self.managedObjectContext];
    newTag.title = title;
    [newTag addItems:[NSSet setWithObject:item]];
    [tags addObject:newTag];
  }
  [item setValue:tags forKeyPath:@"tags"];

  /// モデルを保存する
  NSError *error = nil;
  if (![self.managedObjectContext save:&error]) {
    NSLog(@"error = %@", error);
  } else {
    NSLog(@"Update Completed.");
  }
}

/**
 * @brief 入力画面を出す
 */
- (void)inputAndInsertNewObjectFromModalView
{
  InputModalViewController *inputView = [[InputModalViewController alloc] init];

  [inputView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
  [inputView setDelegate:self];

  [self presentViewController:inputView
                     animated:YES
                   completion:nil];
}

/**
 * @brief 新しい項目を追加する
 */
- (void)insertNewObject:(id)sender
                   data:(NSArray *)data
{
  NSLog(@"%s", __FUNCTION__);
  // ここはよくわからない
  // 特になくても、直接指定すればいいのでは？
  NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
  NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];

  /* 新しい項目を初期化・追加する */
  Item *newItem = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                                inManagedObjectContext:context];

  // If appropriate, configure the new managed object.
  // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
  //    [newManagedObject setValuesForKeysWithDictionary:nsdictionary];

  /* 項目を設定する */
  [newItem setValue:data[0] forKey:@"title"];                        // タイトルを設定
  [newItem setValue:[NSNumber numberWithBool:false] forKey:@"state"]; // 初めは偽に設定
  Tag *newTags = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                               inManagedObjectContext:context];
  [newTags setTitle:data[1]];                                        // タグにタイトルを設定する
  [newItem addTagsObject:newTags];                                   // アイテムにタグを設定する

  // Save the context.
  NSError *error = nil;
  if (![context save:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
}

#pragma mark - Table View

/**
 * テーブルを更新する
 */
- (void)updateTableView
{
  NSLog(@"%s", __FUNCTION__);
  [self.tableView reloadData];
}

/**
 * セルを設定する
 */
- (void)configureCell:(Cell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
  Item *object = [[self fetchedResultsControllerForSelectedTag] objectAtIndexPath:indexPath];
  cell.textLabel.text = [[object valueForKey:@"title"] description]; // text
  [cell updateCheckBox:[[object valueForKey:@"state"] boolValue]];   // checkbox
  cell.delegate = self;                                              // delegate
}

/**
 * @brief セルが選択された時の処理
 */
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  DetailViewController *detailViewController = [[DetailViewController alloc] init];
  Item *object = [[self fetchedResultsControllerForSelectedTag] objectAtIndexPath:indexPath];

  [detailViewController setDetailItem:object];
  [detailViewController setIndex:indexPath];
  [detailViewController setDelegate:self];

  [self.navigationController pushViewController:detailViewController
                                       animated:NO];
}

/**
 * @brief セクション数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[[self fetchedResultsControllerForSelectedTag] sections] count];
}

/**
 * @brief セクション内の項目数
 */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  id <NSFetchedResultsSectionInfo> sectionInfo
  = [[self fetchedResultsControllerForSelectedTag] sections][section];
  return [sectionInfo numberOfObjects];
}

/**
 * @brief indexPath列目のセルを返す
 */
- (Cell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"%s", __FUNCTION__);
  static NSString *CellIdentifier = @"Cell";
  Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

/**
 * @brief テーブル編集の可否
 */
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // Return NO if you do not want the specified item to be editable.
  return YES;
}

/**
 * @brief 編集時の処理
 */
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  /// 削除時
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSLog(@"%@", @"削除開始");
    NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
    [context deleteObject:[[self fetchedResultsControllerForSelectedTag] objectAtIndexPath:indexPath]];

    NSError *error = nil;
    if (![context save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      NSLog(@"%@", [context registeredObjects]);
      abort();
    }
    NSLog(@"%@", @"削除終了");
  }
}

/**
 * @brief ？？？
 */
- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // The table view should not be re-orderable.
  return YES;
}

/**
 * @brief ？？？
 */
-(void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
     toIndexPath:(NSIndexPath *)destinationIndexPath
{
  NSLog(@"%s", "Moved");
}

#pragma mark - Fetched results controller

/**
 * @brief フェッチリザルトコントローラーを取得
 */
- (NSFetchedResultsController *)fetchedResultsController
{
  NSLog(@"%s", __FUNCTION__);
  NSLog(@"%@", _fetchedResultsController);
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                            inManagedObjectContext:self.managedObjectContext];
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
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil]; //< 元は@"Master"

//  aFetchedResultsController.delegate = self; //< デリゲートを設定

  self.fetchedResultsController = aFetchedResultsController;

	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return _fetchedResultsController;
}

/**
 * タグに合わせたオブジェクトを抽出する
 *
 * @param tagString 抽出するタグ
 *
 * @todo タグを複数指定できるようにする。
 *       キャッシュをタグで変える
 */
- (NSFetchedResultsController *)fetchedResultsControllerForTag:(NSString *)tagString
{
  NSLog(@"%s", __FUNCTION__);
  NSLog(@"%@", _fetchedResultsControllerForTag);
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item"
                                            inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];

  /// Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];

  /// ソート条件
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                                 ascending:NO];
  NSArray *sortDescriptors = @[sortDescriptor];
  [fetchRequest setSortDescriptors:sortDescriptors];                 /// ソートを設定

  /// 検索条件
  /// @details 選択されたタグを持つアイテムを列挙
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY SELF.tags.title == %@", tagString];
  [fetchRequest setPredicate:predicate];

  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController
  = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.managedObjectContext
                                          sectionNameKeyPath:nil
                                                   cacheName:nil];   //< タグをキャッシュネームにする
  aFetchedResultsController.delegate = self; //< デリゲートを設定

  _fetchedResultsControllerForTag = aFetchedResultsController;

  /// フェッチを実行
	NSError *error = nil;
	if (![_fetchedResultsControllerForTag performFetch:&error]) {
    // Replace this implementation with code to handle the error appropriately.
    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
	}
  return _fetchedResultsControllerForTag;
}

/**
 * 選択されたタグのアイテムを抽出する
 */
- (NSFetchedResultsController *)fetchedResultsControllerForSelectedTag
{
  NSLog(@"%s", __FUNCTION__);
  if (self.selectedTagString == nil) {
    return [self fetchedResultsController];
  } else {
    NSLog(@"selected: %@", self.selectedTagString);
    return [self fetchedResultsControllerForTag:self.selectedTagString];
  }
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
  switch(type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeDelete:
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

/**
 * リザルトコントローラーが変更を受け取った時の処理
 */
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  NSLog(@"controller: %@", controller);
  UITableView *tableView = self.tableView;

  switch(type) {
    case NSFetchedResultsChangeInsert:
      NSLog(@"%@", @"insert");
      [tableView insertRowsAtIndexPaths:@[newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeDelete:
      NSLog(@"%@", @"delete");
      [tableView deleteRowsAtIndexPaths:@[indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeUpdate:
      NSLog(@"%@", @"update");
      [self configureCell:(Cell *)[tableView cellForRowAtIndexPath:indexPath]
              atIndexPath:indexPath];                                // これであってる？？
      break;

    case NSFetchedResultsChangeMove:
      NSLog(@"%@", @"move");
      [tableView deleteRowsAtIndexPaths:@[indexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:@[newIndexPath]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 */

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  NSLog(@"%s", __FUNCTION__);
  // In the simplest, most efficient, case, reload the table view.
  [self.tableView endUpdates];
}

/**
 * @brief メモリー警告
 */
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
