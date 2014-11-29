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

static NSString *kItemCellID = @"ItemCell";
static NSString *kInputHeaderCellID = @"InputHeaderCell";

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
  
  self.navbarThemeColor = ITEM_COLOR;
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

  //////////////////////////////////////////////////////////////////////////////
  // セルとして使うクラスを登録する
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ItemCell class])
                                             bundle:nil]
       forCellReuseIdentifier:kItemCellID];
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([InputHeaderCell class])
                                             bundle:nil]
       forCellReuseIdentifier:kInputHeaderCellID];
  
  //////////////////////////////////////////////////////////////////////////////
  // 編集・追加ボタン
  self.navigationItem.leftBarButtonItem = [self newEditTableButton];
  self.navigationItem.leftBarButtonItem.tintColor = ITEM_COLOR;
  self.navigationItem.rightBarButtonItem = [self newInsertObjectButton];
  self.navigationItem.rightBarButtonItem.tintColor = ITEM_COLOR;
}

-(void)didTappedEditTableButton
{
  [super didTappedEditTableButton];
  InputHeaderCell *cell = (InputHeaderCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
  [cell.inputField resignFirstResponder];
  [self toEdit:self];
}

-(void)didTappedInsertObjectButton
{
  [super didTappedInsertObjectButton];
  [self presentInputItemView];
}

-(void)dismissTagSelectView:(NSSet *)tagsForSelectedRows
{
  Tag *selectedTag;
  for (Tag *tag in tagsForSelectedRows) {
    // １つだけ
    selectedTag = tag;
    break;
  }
  NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
  if (self.tableView.editing) {
    for (NSIndexPath *indexPathInTable in selectedRows) {
      NSIndexPath *indexPathInController = [self mapIndexPathToFetchResultsController:indexPathInTable];
      Item *item = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
      [item setTag:selectedTag];
    }
    [self instantMessage:@"Move"
                   color:nil];
    [CoreDataController saveContext];
  }
}
/**
 * @brief  全選択する
 *
 * @param sender センダー
 */
-(void)selectAllRows:(id)sender
{
  LOG(@"全選択");
  NSArray *objects = [self.fetchedResultsController fetchedObjects];
  for (NSManagedObject *obj in objects) {
    NSIndexPath *indexPathInController = [self.fetchedResultsController indexPathForObject:obj];
    NSIndexPath *indexPathInTable = [self mapIndexPathFromFetchResultsController:indexPathInController];
    [self.tableView selectRowAtIndexPath:indexPathInTable
                                animated:NO
                          scrollPosition:UITableViewScrollPositionNone];
  }
  [self updateEditTabBar];
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
    sectionTitle = @"others";
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

- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section {
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
  
  header.textLabel.textColor = [UIColor grayColor];
  header.textLabel.font = [UIFont boldSystemFontOfSize:15];
  CGRect headerFrame = header.frame;
  header.textLabel.frame = headerFrame;
}

-(void)deleteAllSelectedRows:(id)sender
{
  LOG(@"全削除");
  for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
    NSIndexPath *indexPathInController = [self mapIndexPathToFetchResultsController:indexPath];
    NSManagedObject *item = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
    [[self.fetchedResultsController managedObjectContext] deleteObject:item];
  }
}

#pragma mark セル

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = kItemCellID;
  if ([self isInputHeaderCellAtIndexPathInTableView:indexPath]) {
    identifier = kInputHeaderCellID;
  }
  return CGRectGetHeight([[self.tableView dequeueReusableCellWithIdentifier:identifier] frame]);
}

/**
 *  @brief セルが選択された時の処理
 *
 *  @param tableView テーブルビュー
 *  @param indexPath 選択された場所
 */
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  if (tableView.isEditing) {
    return;
  }
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
  LOG(@"%ld", (long)number);
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

  if ([self isInputHeaderCellAtIndexPathInTableView:indexPathInTableView])
  {
    // 入力セル
    InputHeaderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"InputHeaderCell"];
    NSString *placeholder;
    if ([self selectedTag]) {
      placeholder = [NSString stringWithFormat:@"new item with \"%@\"", [self selectedTag].title];
    } else {
      placeholder = @"new item";
    }

    cell.delegate = self;
    cell.inputField.delegate = self;
    cell.inputField.placeholder = placeholder;
    return cell;
  }

  ItemCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kItemCellID];
  [self configureItemCell:cell
              atIndexPath:indexPathInTableView];
  return cell;
}

/**
 * @brief  リターンキーが押された時の処理
 *
 * @param textField テキストフィールド
 *
 * @return 真偽値
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  if ([textField.text isEqualToString:@""])
  {
    // キーボードを閉じる
    [textField resignFirstResponder];
  } else
  {
    [self didInputtedNewItem:textField.text];
    textField.text = @"";
  }
  return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//  if (self.tableView.isEditing) {
//    return NO;
//  }
  return YES;
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
                                tag:[self selectedTag]
                           reminder:nil];
  [self instantMessage:@"Saved"
                 color:nil];
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
  
  // チェックボックスを設定する
  [cell updateCheckBoxWithItem:item];

  
  // リマインダーラベル
  NSString *reminderText;
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"yyyy/MM/dd";
  if (item.reminder) {
    reminderText = [formatter stringFromDate:item.reminder];
  } else {
    reminderText = @"";
  }
  cell.reminderLabel.text = reminderText;
  
  // テキストの色を変更する
  UIColor *textColor;

  if ([item isDueToToday]) {
    // 今日まで
    textColor = DUE_TO_TODAY_COLOR;
  } else if([item isOverDue]) {
    // 期限超過
    textColor = OVERDUE_COLOR;
  } else if([item hasDueDate]) {
    // 単純に期限付き
    textColor = HAS_DUE_DATE_COLOR;
  } else {
    // その他
    textColor = GRAY_COLOR;
  }
  cell.reminderLabel.textColor = textColor;
  
  // 画像タッチを認識する設定
  UILongPressGestureRecognizer *recognizer
  = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(didTappedCheckBox:)];
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
- (void)didTappedCheckBox:(UILongPressGestureRecognizer *)sender
{
  static ItemCell *selected_cell = nil;
  static Item *selected_item = nil;
  
  switch (sender.state) {
    case UIGestureRecognizerStateBegan:
    {
      LOG(@"チェックボックスのタッチ開始");
      CGPoint point = [sender locationInView:self.tableView];
      NSIndexPath *indexPathInTableView = [self.tableView indexPathForRowAtPoint:point];
      NSIndexPath *indexPathInController = [self mapIndexPathToFetchResultsController:indexPathInTableView];
      Item *item = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
      
      // その位置のセルのデータをモデルから取得する
      ItemCell *cell = (ItemCell *)[self.tableView cellForRowAtIndexPath:indexPathInTableView];

      selected_cell = cell;
      selected_item = item;
      
      [selected_cell setCheckedWithItem:selected_item];
    }
      break;
      
    case UIGestureRecognizerStateEnded:
    {
      LOG(@"チェックボックスのタッチ終了");
      CGPoint point = [sender locationInView:self.tableView];
      NSIndexPath *indexPathInTableView = [self.tableView indexPathForRowAtPoint:point];
      NSIndexPath *indexPathInController = [self mapIndexPathToFetchResultsController:indexPathInTableView];
//      Item *item = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
      
      // その位置のセルのデータをモデルから取得する
    
      LOG(@"モデルを取得");
      if (indexPathInController.section < 0) {
        [selected_cell setUnCheckedWithItem:selected_item];
        return;
      }
      ItemCell *cell = (ItemCell *)[self.tableView cellForRowAtIndexPath:indexPathInTableView];
      
      if (selected_cell == cell) {
        // チェックをつける
        selected_item.state = [NSNumber numberWithBool:true];
        [selected_item setComplete];
        [CoreDataController saveContext];
      } else {
        [selected_cell setUnCheckedWithItem:selected_item];
      }
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
  return NO;
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
  
  detailViewController.navigationController = self.navigationController;
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
  detailViewController.navigationController = self.navigationController;
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
  NSString *message;
  if (isNewItem) {
    message = @"Saved";
  } else {
    message = @"Update";
  }
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

  Tag *selectedTag;
  for (Tag *tag in tags) {
    // １個だけ挿入する
    selectedTag = tag;
    break;
  }
  
  BOOL showInstantMessage = NO;
  if ( ! [item.title isEqualToString:title] || ! [item isEqualDueDate:reminder] || item.tag != selectedTag) {
    showInstantMessage = YES;
  }
  item.title = title;
  item.state = [NSNumber numberWithBool:false];
  item.reminder = reminder;
  item.tag = selectedTag;
  LOG(@"%@", item);
  [CoreDataController saveContext];
  
  if (showInstantMessage) {
    [self instantMessage:message
                   color:nil];
  }
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  if (self.tableView.editing == NO) {
    [self.delegateForList openTabBar];
  } else {
    [self updateEditTabBar];
  }
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

/**
 * @brief  選択されたタグの先頭を返す
 *
 * @return タグオブジェクト
 */
-(Tag *)selectedTag
{
  if (self.selectedTags == nil) {
    return nil;
  }
  Tag *selected_tag;
  for (Tag *tag in self.selectedTags) {
    selected_tag = tag;
    break;
  }
  return selected_tag;
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
