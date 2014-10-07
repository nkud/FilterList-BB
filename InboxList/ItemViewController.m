//
//  MasterViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "AppDelegate.h"
#import "ItemViewController.h"
#import "ItemNavigationController.h"
#import "ItemDetailViewController.h"
#import "Tag.h"
#import "Item.h"
#import "ItemCell.h"
#import "InputHeaderCell.h"
#import "TagLabel.h"

#import "Header.h"
#import "Configure.h"
#import "CoreDataController.h"

#define kHeightForSection 22

#pragma mark -

@interface ItemViewController () {
  int location_center_x;
  BOOL isOpen;
  AppDelegate *app;
  
  NSInteger heightForSection_;
}

- (void)configureItemCell:(ItemCell *)cell
          atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation ItemViewController

#pragma mark - 初期化 -

/**
 * @brief  パラメータの初期化
 */
- (void)initParameter
{
  isOpen = false;
  app = [[UIApplication sharedApplication] delegate];
  heightForSection_ = kHeightForSection;
}

/**
 * @brief  初期化
 *
 * @param nibNameOrNil   nibNameOrNil description
 * @param nibBundleOrNil nibBundleOrNil description
 *
 * @return インスタンス
 */
-(instancetype)initWithNibName:(NSString *)nibNameOrNil
                        bundle:(NSBundle *)nibBundleOrNil
{
  LOG(@"アイテムリスト初期化");
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  return self;
}

/**
 * @brief  ビューのロード後処理
 */
- (void)viewDidLoad
{
  LOG(@"アイテムビューがロードされた後の処理");
  // 継承元のロード
  [super viewDidLoad];

  // 変数を初期化
  [self initParameter];

  // セルとして使うクラスを登録する
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ItemCell class])
                                             bundle:nil]
       forCellReuseIdentifier:@"ItemCell"];
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InputHeaderCell class])
                                             bundle:nil]
       forCellReuseIdentifier:@"InputHeaderCell"];
  
  // 編集ボタン
  UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(toEdit:)];
  self.navigationItem.leftBarButtonItem = editButton;

  // 新規ボタン
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(presentInputItemView)];
  self.navigationItem.rightBarButtonItem = addButton;
}

#pragma mark - テーブルビュー

#pragma mark セクション

/**
 * @brief  セクションの高さ
 *
 * @param tableView テーブルビュー
 * @param section   セクション
 *
 * @return 高さ
 */
-(CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
  // クイック入力セル用
  if (section == 0) {
    return 0;
  }
  // 通常のアイテムセル用
  return heightForSection_;
}

/**
 * @brief  セクションのタイトル
 *
 * @param tableView テーブルビュー
 * @param section   セクション
 *
 * @return タイトル
 */
-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
  if (section == 0) {
    // クイック入力用のセルのセクションはなし
    return @"! input header";
  }
  // セクション名を取得
  NSInteger sectionForController = section - 1;
  id <NSFetchedResultsSectionInfo> sectionInfo
  = [[self.fetchedResultsController sections] objectAtIndex:sectionForController];

  NSString *sectionTitle = [sectionInfo name];
  if ([sectionTitle isEqualToString:@""]) {
    sectionTitle = @"no tag";
  }
  
  LOG(@"section:%ld - %@ (count: %ld)", (long)sectionForController, sectionTitle, [sectionInfo numberOfObjects]);
  return sectionTitle;
}

/**
 *  @brief セクション数を返す
 *
 *  @param tableView テーブルビュー
 *
 *  @return セクション数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  LOG(@"セクション数を返す");
  // クイック入力セルを足している
  return [[self.fetchedResultsController sections] count] + 1;
}

#pragma mark セル

/**
 *  @brief セルが選択された時の処理
 *
 *  @param tableView テーブルビュー
 *  @param indexPath 選択された場所
 */
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSIndexPath *indexPathInTableView = indexPath;
  if ([self isInputHeaderCellAtIndexPathInTableView:indexPathInTableView])
  {
    ;
  } else {
    LOG(@"アイテムセルが選択された時の処理");
    // インデックスの詳細画面をプッシュする
    [self pushDetailViewAtIndexPathInTableView:indexPathInTableView];
    // 選択状態を消す
    [self.tableView deselectRowAtIndexPath:indexPathInTableView
                                  animated:YES];
  }
}

/**
 *  @brief 指定されたセクションのアイテム数
 *
 *  @param tableView テーブルビュー
 *  @param section   セクション
 *
 *  @return アイテム数
 */
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
  NSInteger number = 0;
  if (section == 0) {
    // クイック入力セルの場合
    number = 1;
  } else {
    // 通常アイテムセルの場合
    NSInteger sectionInController = [self mapSectionToFetchedResultsController:section];
    id <NSFetchedResultsSectionInfo> sectionInfo
    = [self.fetchedResultsController sections][sectionInController];
    number = [sectionInfo numberOfObjects];
  }
  return number;
}

/**
 *  @brief 指定された位置のセル
 *
 *  @param tableView テーブルビュー
 *  @param indexPath 指定する位置
 *
 *  @return セル
 */
- (UITableViewCell *)tableView:(UITableView *)tableView
  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSIndexPath *indexPathInTableView = indexPath;
  
  LOG(@"指定されたセルを返す");
  if ([self isInputHeaderCellAtIndexPathInTableView:indexPathInTableView]) {
    InputHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"InputHeaderCell"];
    cell.delegate = self;
    return cell;
  }
  static NSString *CellIdentifier = @"ItemCell";
  ItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  [self configureItemCell:cell
              atIndexPath:indexPathInTableView];
  return cell;
}

/**
 *  @brief テーブル編集の可否
 *
 *  @param tableView テーブルビュー
 *  @param indexPath 位置
 *
 *  @return 真偽値
 */
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSIndexPath *indexPathInTableView = indexPath;
  if ([self isInputHeaderCellAtIndexPathInTableView:indexPathInTableView]) {
    return NO;
  }
  return YES;
}

/**
 * @brief テーブルビューを更新する
 *
 * @todo 効率のいい更新方法にする
 */

- (void)updateTableView
{
  LOG(@"テーブルビューの全てを更新");
  [self.tableView reloadData];
}

#pragma mark - クイック入力処理

-(void)didInputtedNewItem:(NSString *)titleForItem
{
  LOG(@"クイック入力タイトル:%@", titleForItem);

  [CoreDataController insertNewItem:titleForItem
                                tag:self.tagForSelected
                           reminder:nil];
}

#pragma mark - セル設定

/**
 *  @brief セルを作成する
 *
 *  @param cell      作成するセル
 *  @param indexPath 作成するセルの位置
 */
- (void)configureItemCell:(ItemCell *)cell
              atIndexPath:(NSIndexPath *)indexPath
{
  LOG(@"セルを作成");
  /// セルを作成
  Item *item = [self itemAtIndexPathInTableView:indexPath];
  
  // タイトル
  cell.titleLabel.text = item.title;
  cell.tagLabel.text = item.tag.title;
  
  // 状態
  [cell updateCheckBox:item.state.boolValue];
  
  // リマインダー
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy/MM/dd";
  cell.reminderLabel.text = [formatter stringFromDate:item.reminder];
  if ([item isOverDue]) {
    cell.reminderLabel.textColor = [UIColor redColor];
  } else {
    cell.reminderLabel.textColor = [UIColor grayColor];
  }
  
  // 画像タッチを認識する設定
  UILongPressGestureRecognizer *recognizer
  = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(touchedCheckBox:)];
  /// @todo ここはうまくしたい
  [recognizer setMinimumPressDuration:0.0];
  [cell.checkBoxImageView setUserInteractionEnabled:YES];
  [cell.checkBoxImageView addGestureRecognizer:recognizer];
}
/**
 * @brief  チェックボックスがタッチされた時の処理
 *
 * @param sender タップリコクナイザー
 * @todo なんかおかしい
 */
- (void)touchedCheckBox:(UILongPressGestureRecognizer *)sender
{
//  static bool flag = false;
  static ItemCell *selected_cell = nil;
  
  switch (sender.state) {
    case UIGestureRecognizerStateBegan:
    {
      LOG(@"チェックボックスのタッチ開始");
      CGPoint point = [sender locationInView:self.tableView];
      NSIndexPath *indexPathInTableView = [self.tableView indexPathForRowAtPoint:point];
      
      // その位置のセルのデータをモデルから取得する
//      NSIndexPath *indexPathInController = [self mapIndexPathToFetchResultsController:indexPathInTableView];
//      Item *item = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
      ItemCell *cell = (ItemCell *)[self.tableView cellForRowAtIndexPath:indexPathInTableView];

      selected_cell = cell;
      [selected_cell setChecked];
      
//      if ([item.state boolValue]) { // 完了済みなら
//        LOG(@"未完了に変更");
//        item.state = [NSNumber numberWithBool:false]; // 未完了にする
//      } else { // 未完了なら
//        LOG(@"完了に変更して削除する前処理");
//        item.state = [NSNumber numberWithBool:true]; // 完了にして
//        flag = true; // 削除する
//      }
    }
      break;
      
    case UIGestureRecognizerStateEnded:
    {
      LOG(@"チェックボックスのタッチ終了");
      CGPoint point = [sender locationInView:self.tableView];
      NSIndexPath *indexPathInTableView = [self.tableView indexPathForRowAtPoint:point];
      
      // その位置のセルのデータをモデルから取得する
      
      NSIndexPath *indexPathInController = [self mapIndexPathToFetchResultsController:indexPathInTableView];
      LOG(@"モデルを取得");
      Item *item = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
      ItemCell *cell = (ItemCell *)[self.tableView cellForRowAtIndexPath:indexPathInTableView];
      
      if (selected_cell == cell) {
        item.state = [NSNumber numberWithBool:true];
        [CoreDataController saveContext];
      } else {
        [selected_cell setUnChecked];
      }
      
//      if ( flag ) {
//        LOG(@"アイテムを削除する");
//        [app.managedObjectContext deleteObject:item]; // アイテムを削除
//      }
      
      [CoreDataController saveContext];
    }
      break;
      
    default:
      break;
  }
}
#pragma mark - 編集時処理

/**
 *  @brief 編集
 *
 *  @param sender センダー
 */
- (void)toEdit:(id)sender
{
  LOG(@"編集モード");
  if (self.tableView.isEditing) {
    LOG(@"編集モードの場合");
    [self.tableView setEditing:false
                      animated:YES];
  } else {
    LOG(@"編集モードでない場合");
    [self.tableView setEditing:true
                      animated:YES];
  }
}

/**
 *  @brief 編集時の処理
 *
 *  @param tableView    テーブルビュー
 *  @param editingStyle 編集スタイル
 *  @param indexPath    選択された位置
 */
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSIndexPath *indexPathInTableView = indexPath;
  NSIndexPath *indexPathInController
  = [self mapIndexPathToFetchResultsController:indexPathInTableView];
  LOG(@"テーブル編集時の処理");
  /// 削除時
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController
                           objectAtIndexPath:indexPathInController]];
    [app saveContext];
  }
}

/**
 * @brief  セルが移動できるか評価する
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 *
 * @return 真偽値
 */
- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSIndexPath *indexPathInTableView = [self mapIndexPathToFetchResultsController:indexPath];
  // The table view should not be re-orderable.
  if ([self isInputHeaderCellAtIndexPathInTableView:indexPathInTableView]) {
    return NO;
  }
  return YES;
}

/**
 * @brief  セルを移動する？？？
 *
 * @param tableView            テーブルビュー
 * @param sourceIndexPath      元の位置
 * @param destinationIndexPath 移動先の位置
 */
-(void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
     toIndexPath:(NSIndexPath *)destinationIndexPath
{
  LOG(@"移動");
  sourceIndexPath = [self mapIndexPathToFetchResultsController:sourceIndexPath];
  destinationIndexPath = [self mapIndexPathToFetchResultsController:destinationIndexPath];
}

#pragma mark - 入力画面処理

/**
 * @brief  入力画面を表示する
 *
 * @todo あらかじめインスタンスを作っておく
 */
-(void)presentInputItemView
{
  // タブバーを閉じる
  [self.delegateForList closeTabBar];
  
  LOG(@"入力画面を表示");
  ItemDetailViewController *detailViewController
  = [[ItemDetailViewController alloc] initWithTitle:nil
                                               tags:nil
                                           reminder:nil
                                          indexPath:nil
                                           delegate:self];
  [self.navigationController pushViewController:detailViewController
                                       animated:YES];
}

#pragma mark - 詳細画面処理

/**
 * @brief  詳細画面をプッシュする
 *
 * @param indexPath 作成する詳細のセルの位置
 */
-(void)pushDetailViewAtIndexPathInTableView:(NSIndexPath *)indexPathInTableView
{
  // タブバーを閉じる
  [self.delegateForList closeTabBar];
  
  // セルの位置のアイテムを取得
  NSIndexPath *indexPathInController
  = [self mapIndexPathToFetchResultsController:indexPathInTableView];
  Item *item = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
  
  // 詳細画面を作成
  ItemDetailViewController *detailViewController;
  if (item.tag) {
    NSSet *tags;
    tags = [NSSet setWithObject:item.tag];
    detailViewController
    = [[ItemDetailViewController alloc] initWithTitle:item.title
                                                 tags:[NSSet setWithObject:item.tag]
                                             reminder:item.reminder
                                            indexPath:indexPathInController
                                             delegate:self];
  } else {
    detailViewController
    = [[ItemDetailViewController alloc] initWithTitle:item.title
                                                 tags:nil
                                             reminder:item.reminder
                                            indexPath:indexPathInController
                                             delegate:self];
  }


  // 詳細画面をプッシュ
  [self.navigationController pushViewController:detailViewController
                                       animated:NO];
}

/**
 * @brief  詳細ビューを削除する前の処理
 *
 * @param sender    詳細ビュー
 * @param title     タイトル
 * @param tags      タグ
 * @param reminder  リマインダー
 * @param indexPath 位置
 * @param isNewItem 新規かどうか
 */
-(void)dismissDetailView:(id)sender
                   title:(NSString *)title
                    tags:(NSSet *)tags
                reminder:(NSDate *)reminder
               indexPath:(NSIndexPath *)indexPath
               isNewItem:(BOOL)isNewItem
{
  // タブバーを開ける
  LOG(@"%@", title);
  Item *item;
  if (isNewItem) {
    // 新規にアイテムを作成
    if ([title isEqualToString:@""])
    {
      // タイトルが空白なら終了
      return;
    }
    item = [CoreDataController newItemObject];
  } else
  {
    // 更新するアイテムを取得
    item = [self.fetchedResultsController objectAtIndexPath:indexPath];
  }
  item.title = title;
  for (Tag *tag in tags) {
    // １個だけ挿入する
    item.tag = tag;
    break;
  }
  item.reminder = reminder;
  
  [CoreDataController saveContext];
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.delegateForList openTabBar];
}


#pragma mark - ユーティリティ

-(void)showSectionHeader
{
  heightForSection_ = kHeightForSection;
}
-(void)hideSectionHeader
{
  heightForSection_ = 0;
}

/**
 * @brief  テーブルビューでの位置からアイテムを取得する
 *
 * @param atIndexPath 位置
 *
 * @return アイテムオブジェクト
 */
-(Item *)itemAtIndexPathInTableView:(NSIndexPath *)atIndexPath
{
  NSIndexPath *indexPath = [self mapIndexPathToFetchResultsController:atIndexPath];
  Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
  return item;
}

/**
 * @brief  クイック入力セルなら真を返す
 *
 * @param indexPath 位置
 *
 * @return 真偽値
 */
-(BOOL)isInputHeaderCellAtIndexPathInTableView:(NSIndexPath *)indexPathInTableView
{
  if ( indexPathInTableView.section == 0) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - コントローラー用のマップ関数

/**
 * @brief  リザルトコントローラー -> インデックス
 *
 * @param indexPath インデックス
 *
 * @return インデックス
 */
- (NSIndexPath *)mapIndexPathFromFetchResultsController:(NSIndexPath *)indexPath
{
  NSInteger section = [self mapSectionFromFetchedResultsController:indexPath.section];
  indexPath = [NSIndexPath indexPathForRow:indexPath.row
                                 inSection:section];
  
  return indexPath;
}

-(NSInteger)mapSectionFromFetchedResultsController:(NSInteger)section
{
  section = section + 1;
  return section;
}
-(NSInteger)mapSectionToFetchedResultsController:(NSInteger)section
{
  section = section - 1;
  return section;
}

/**
 * @brief  インデックス -> リザルトコントローラー
 *
 * @param indexPath インデックス
 *
 * @return インデックス
 */
- (NSIndexPath *)mapIndexPathToFetchResultsController:(NSIndexPath *)indexPath
{
  NSInteger section = [self mapSectionToFetchedResultsController:indexPath.section];
  indexPath = [NSIndexPath indexPathForRow:indexPath.row
                                 inSection:section];
  
  return indexPath;
}

#pragma mark - コンテンツの更新

/**
 *  @brief コンテンツを更新する前処理
 *
 *  @param controller リザルトコントローラー
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  LOG(@"アイテムビューを更新する前の処理");
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
  LOG(@"アイテムビューを更新する処理");
  sectionIndex = [self mapSectionFromFetchedResultsController:sectionIndex];
  switch(type) {
    case NSFetchedResultsChangeInsert:
      LOG(@"セクション挿入");
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationLeft];
      break;

    case NSFetchedResultsChangeDelete:
      LOG(@"セクション削除");
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationLeft];
      break;
    case NSFetchedResultsChangeMove: // by ios8
      LOG(@"セクション移動");
      break;
    case NSFetchedResultsChangeUpdate:
      LOG(@"セクション更新");
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  indexPath = [self mapIndexPathFromFetchResultsController:indexPath];
  newIndexPath = [self mapIndexPathFromFetchResultsController:newIndexPath];
  
  LOG(@"アイテムビューを更新する処理");
  UITableView *tableView = self.tableView;

  switch(type) {
    case NSFetchedResultsChangeInsert:
      LOG(@"挿入");
      [tableView insertRowsAtIndexPaths:@[newIndexPath]
                       withRowAnimation:UITableViewRowAnimationLeft];
      break;

    case NSFetchedResultsChangeDelete:
    {
      LOG(@"削除");
      [tableView deleteRowsAtIndexPaths:@[indexPath]
                       withRowAnimation:UITableViewRowAnimationLeft];
      break;
    }
      
    case NSFetchedResultsChangeUpdate:
      LOG(@"更新");
      [self configureItemCell:(ItemCell *)[tableView cellForRowAtIndexPath:indexPath]
              atIndexPath:indexPath];                                // これであってる？？
      
      break;

    case NSFetchedResultsChangeMove:
      LOG(@"移動");
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

/**
 *  @brief コンテンツが更新された後処理
 *
 *  @param controller リザルトコントローラー
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  LOG(@"アイテムビューが更新されたあとの処理");
  // In the simplest, most efficient, case, reload the table view.
  [self.tableView endUpdates];
}

#pragma mark - その他

/**
 *  @brief メモリー警告
 */
- (void)didReceiveMemoryWarning
{
  LOG(@"メモリー警告");
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
