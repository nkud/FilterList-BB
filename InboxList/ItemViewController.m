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

#pragma mark -

@interface ItemViewController () {
  int location_center_x;
  BOOL isOpen;
  AppDelegate *app;
}

- (void)configureItemCell:(ItemCell *)cell
          atIndexPath:(NSIndexPath *)indexPath;
@end


@implementation ItemViewController

#pragma mark - 初期化

/**
 * @brief  パラメータの初期化
 */
- (void)initParameter
{
  isOpen = false;
  if (self.titleForList == nil) {
    self.titleForList = @"all";
  }
  app = [[UIApplication sharedApplication] delegate];
}

/**
 * @brief  タイトルを設定
 *
 * @param title     メインタイトル
 * @param miniTitle サブタイトル
 */
-(void)configureTitleWithString:(NSString *)title
                      miniTitle:(NSString *)miniTitle
{
  UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
  titleView.backgroundColor = [UIColor clearColor];
  titleView.opaque = NO;
  // ☆☆ポイントはここ！！
  // 以下のように代入して、タイトルに独自Viewを表示します。
  self.navigationItem.titleView = titleView;
  
  // 1行目に表示するラベルを作成して、
  // 上記で作成した独自Viewに追加します。
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 20)];
  titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
  titleLabel.text = title;
  titleLabel.textColor = [UIColor blackColor];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.backgroundColor = [UIColor clearColor];
  [titleView addSubview:titleLabel];
  
  // 2行目に表示するラベルを作成して、
  // 上記で作成した独自Viewに追加します。
  UILabel *miniTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 195, 20)];
  miniTitleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
  miniTitleLabel.textColor = [UIColor grayColor];
  miniTitleLabel.textAlignment = NSTextAlignmentCenter;
  miniTitleLabel.backgroundColor = [UIColor clearColor];
  miniTitleLabel.adjustsFontSizeToFitWidth = YES;
  miniTitleLabel.text = miniTitle;
  [titleView addSubview:miniTitleLabel];
}

/**
 * @brief  ビューのロード後処理
 */
- (void)viewDidLoad
{
  LOG(@"アイテムビューがロードされた後の処理");
  [super viewDidLoad];
  

  // タイトルを設定
  self.stringForTitle = ITEM_LIST_TITLE;
  self.stringForMiniTitle = @"mini title";
  [self configureTitleWithString:self.stringForTitle
                       miniTitle:self.stringForMiniTitle];
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
                                                                target:self action:@selector(toEdit:)];
  self.navigationItem.leftBarButtonItem = editButton;

  // 新規ボタン
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(presentInputItemView)];
  self.navigationItem.rightBarButtonItem = addButton;
}

#pragma mark - テーブルビュー

/**
 *  @brief セルが選択された時の処理
 *
 *  @param tableView テーブルビュー
 *  @param indexPath 選択された場所
 */
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LOG(@"アイテムが選択された時の処理");
  if ([self isInputHeaderCellAtIndexPath:indexPath]) {
    ;
  } else {
    // インデックスの詳細画面をプッシュする
    [self pushDetailView:indexPath];
  }
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
  return [[self.fetchedResultsController sections] count];
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
  id <NSFetchedResultsSectionInfo> sectionInfo
  = [self.fetchedResultsController sections][section];
  return [sectionInfo numberOfObjects] + 1;
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
  LOG(@"指定されたセルを返す");
  if ([self isInputHeaderCellAtIndexPath:indexPath]) {
    InputHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InputHeaderCell"];
    cell.delegate = self;
    return cell;
  }
  static NSString *CellIdentifier = @"ItemCell";
  ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  [self configureItemCell:cell
              atIndexPath:indexPath];
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
  if ([self isInputHeaderCellAtIndexPath:indexPath]) {
    return NO;
  }
  return YES;
}


/**
 *  @brief スクロール時の処理
 *
 *  @param scrollView スクロールビュー
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGRect rect = scrollView.bounds; // 現在のスクロールビューの位置を取得して
  self.triggerDragging = rect.origin.y; // ドラッグしている距離を更新
}

/**
 *  @brief スクロールをドラッグした後の処理
 *
 *  @param scrollView スクロールビュー
 *  @param decelerate decelerate description
 *
 *  @todo  入力ヘッダを綺麗に出すようにする
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate
{
  LOG(@"スクロールをドラッグした時の処理");
//  int activate_quick_distance = -120;
  // 規定値よりもドラッグするとクイック入力開始
//  if (self.triggerDragging < -self.inputHeaderCell.frame.size.height)
  {
//    [self toggleQuickInputActivation];
  }
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
  NSLog(@"%s %@", __FUNCTION__, titleForItem);
  [CoreDataController insertNewItem:titleForItem
                               tags:self.tagsForSelected
                           reminder:nil];
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
    [self setEditing:false
            animated:YES];
  } else {
    [self setEditing:true
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
  LOG(@"テーブル編集時の処理");
  /// 削除時
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
    indexPath = [self mapIndexPathToFetchResultsController:indexPath];
    [context deleteObject:[self.fetchedResultsController
                           objectAtIndexPath:indexPath]];
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
  // The table view should not be re-orderable.
  if ([self isInputHeaderCellAtIndexPath:indexPath]) {
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
-(void)pushDetailView:(NSIndexPath *)indexPath
{
  // セルの位置のアイテムを取得
  indexPath = [self mapIndexPathToFetchResultsController:indexPath];
  Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
  // 詳細画面を作成
  ItemDetailViewController *detailViewController
  = [[ItemDetailViewController alloc] initWithTitle:item.title
                                               tags:item.tags
                                           reminder:item.reminder
                                          indexPath:indexPath
                                           delegate:self];

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
    item = [self.fetchedResultsController
            objectAtIndexPath:indexPath];
  }
  item.title = title;
  item.tags = tags;
  item.reminder = reminder;
  
  [CoreDataController saveContext];
}



#pragma mark - セル関連

/**
 *  @brief セルを作成する
 *
 *  @param cell      作成するセル
 *  @param indexPath 作成するセルの位置
 */
- (void)configureItemCell:(ItemCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
  /// セルを作成
  Item *item = [self.fetchedResultsController objectAtIndexPath:[self mapIndexPathToFetchResultsController:indexPath]];
  
  // タイトル
  cell.titleLabel.text = item.title;
  
  // タグの設定
//  cell.tagLabel = [[TagLabel alloc] initWithTagStrings:[NSSet setWithObjects:@"test", @"testt", nil]];
  NSMutableString *tags_string = [NSMutableString stringWithString:@""];
  for (Tag *tag in item.tags) {
    [tags_string appendFormat:@"%@ ", tag.title];
  }
  cell.tagLabel.text = tags_string;
  
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
  UILongPressGestureRecognizer *recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
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
  static bool flag = false;
  switch (sender.state) {
    case UIGestureRecognizerStateBegan:
      //    case UIGestureRecognizerStateChanged:
    {
      LOG(@"チェックボックスのタッチ開始");
      CGPoint point = [sender locationInView:self.tableView];
      NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
      
      // その位置のセルのデータをモデルから取得する
      indexPath = [self mapIndexPathToFetchResultsController:indexPath];
      Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
      
      if ([item.state boolValue]) { // 完了済みなら
        LOG(@"未完了に変更");
        item.state = [NSNumber numberWithBool:false]; // 未完了にする
      } else { // 未完了なら
        LOG(@"完了に変更して削除する前処理");
        item.state = [NSNumber numberWithBool:true]; // 完了にして
        flag = true; // 削除する
      }
    }
      break;
      
    case UIGestureRecognizerStateEnded:
    {
      LOG(@"チェックボックスのタッチ終了");
      CGPoint point = [sender locationInView:self.tableView];
      NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
      
      // その位置のセルのデータをモデルから取得する
      indexPath = [self mapIndexPathToFetchResultsController:indexPath];
      Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
      if ( flag ) {
        LOG(@"アイテムを削除する");
        [app.managedObjectContext deleteObject:item]; // アイテムを削除
      }
      
      [CoreDataController saveContext];
    }
      break;
      
    default:
      break;
  }
}

#pragma mark - CoreData

/**
 *  @brief 新しいオブジェクトを挿入
 *
 *  @param sender      呼び出し元
 *  @param title       アイテムのタイトル
 *  @param tagTitleSet タグのタイトルセット
 *  @param reminder    日付
 */
- (void)insertNewObject:(id)sender
                  title:(NSString *)title
                    tag:(NSSet *)tagTitleSet
               reminder:(NSDate *)reminder
{
  LOG(@"新しいアイテムを挿入");
  NSMutableSet *tags = [[NSMutableSet alloc] init]; // 渡すタグの配列
  for (NSString *title in tagTitleSet) {            // 指定されたタグ名の
    Tag *tag = [[Tag alloc] initWithEntity:[CoreDataController entityDescriptionForName:@"Tag"]
            insertIntoManagedObjectContext:nil];
    tag.title = title;          // タグを作成して
    [tags addObject:tag];       // 配列に追加
  }
  [CoreDataController insertNewItem:title
                               tags:tags
                           reminder:reminder];
}
/**
 *  @brief タイトルだけ指定して新しいアイテムを追加
 *
 *  @param itemString 追加するアイテムのタイトル
 */
-(void)quickInsertNewItem:(NSString *)itemString
{
  LOG(@"タイトルだけ指定して新しいアイテムを追加");
  if ([itemString isEqualToString:@""]) { // 空欄なら
    return;                               // 終了
  }
  if ([self.titleForList isEqualToString:@"all"])
  {                             // 全タグ表示中なら
    [CoreDataController insertNewItem:itemString
                                 tags:nil
                             reminder:[NSDate date]]; // タグなしで追加して終了
  }
  else                          // あるタグを表示中なら
  {
    Tag *tag = [[Tag alloc] initWithEntity:[CoreDataController entityDescriptionForName:@"Tag"]
            insertIntoManagedObjectContext:nil];
    tag.title = self.titleForList;
    NSSet *tags = [NSSet setWithObject:tag];
    [CoreDataController insertNewItem:itemString
                                 tags:tags
                             reminder:[NSDate date]]; // 新しいアイテムを追加
  }
}

#pragma mark - ユーティリティ

-(BOOL)isInputHeaderCellAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0 && indexPath.section == 0 ) {
    return YES;
  } else {
    return NO;
  }
}

/**
 * @brief  リザルトコントローラー -> インデックス
 *
 * @param indexPath インデックス
 *
 * @return インデックス
 */
- (NSIndexPath *)mapIndexPathFromFetchResultsController:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0)
    indexPath = [NSIndexPath indexPathForRow:indexPath.row + 1
                                   inSection:indexPath.section];
  
  return indexPath;
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
  if (indexPath.section == 0)
    indexPath = [NSIndexPath indexPathForRow:indexPath.row - 1
                                   inSection:indexPath.section];
  
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
  switch(type) {
    case NSFetchedResultsChangeInsert:
      NSLog(@"%@", @"Insert");
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeDelete:
      NSLog(@"%@", @"Delete");
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeMove: // by ios8
      NSLog(@"A table item was moved");
      break;
    case NSFetchedResultsChangeUpdate:
      NSLog(@"A table item was updated");
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
