//
//  MasterViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "AppDelegate.h"
#import "ItemViewController.h"
#import "ItemDetailViewController.h"
#import "InputItemViewController.h"
#import "Tag.h"
#import "Item.h"
#import "ItemCell.h"

#import "Header.h"
#import "Configure.h"
#import "CoreDataController.h"

#import "InputItemNavigationController.h"


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
  if (self.selectedTagString == nil) {
    self.selectedTagString = @"all";
  }
  app = [[UIApplication sharedApplication] delegate];
}

/**
 * @brief  ビューのロード後処理
 */
- (void)viewDidLoad
{
  LOG(@"アイテムビューがロードされた後の処理");
  [super viewDidLoad];
  
  // 変数を初期化
  [self setTitle:ITEM_LIST_TITLE];
  [self initParameter];

  // セルとして使うクラスを登録する
  //  [self.tableView registerClass:[ItemCell class] forCellReuseIdentifier:@"ItemCell"];
  [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ItemCell class])
                                             bundle:nil]
       forCellReuseIdentifier:@"ItemCell"];
  //  [self.tableView setRowHeight:100];
  
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
  
  // インデックスの詳細画面をプッシュする
  [self pushDetailView:indexPath];
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
  return [sectionInfo numberOfObjects];
}

/**
 *  @brief 指定された位置のセル
 *
 *  @param tableView テーブルビュー
 *  @param indexPath 指定する位置
 *
 *  @return セル
 */
- (ItemCell *)tableView:(UITableView *)tableView
  cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  LOG(@"指定されたセルを返す");
  static NSString *CellIdentifier = @"ItemCell";
  ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  [self configureItemCell:cell atIndexPath:indexPath];
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
  // Return NO if you do not want the specified item to be editable.
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
  int activate_quick_distance = -120;
  if (self.triggerDragging < activate_quick_distance) { // 規定値よりもドラッグすると
    
    LOG(@"クイック入力開始");
//    [self.inputHeader activateInput]; // クイック入力を作動させる
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
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
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
  InputItemViewController *inputView = [[InputItemViewController alloc] initWithNibName:@"InputItemViewController"
                                                                                 bundle:nil];
  inputView.delegate = self;
  [inputView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
  
  InputItemNavigationController *inputItemNavigationController
  = [[InputItemNavigationController alloc] initWithRootViewController:inputView];
  
  [self presentViewController:inputItemNavigationController
                     animated:YES
                   completion:nil];
}

/**
 * @brief  入力画面を終了させる処理
 *
 * @param title               タイトル
 * @param tagsForSelectedRows 選択されたタグ
 * @param reminder            リマインダー
 */
-(void)dismissInputItemView:(NSString *)itemTitle
        tagsForSelectedRows:(NSSet *)tagsForSelectedRows
                   reminder:(NSDate *)reminder
{
  if ([itemTitle isEqual:@""]) {
    // 空欄なら何もしない
  } else {
    // 新しいアイテムを挿入する
    [CoreDataController insertNewItem:itemTitle
                                 tags:tagsForSelectedRows
                             reminder:reminder];
  }
  
  // 画面を終了する
  [self dismissViewControllerAnimated:YES
                           completion:nil];
}

#pragma mark - 詳細画面処理

/**
 * @brief  詳細画面をプッシュする
 *
 * @param indexPath 作成する詳細のセルの位置
 */
-(void)pushDetailView:(NSIndexPath *)indexPath
{
  // アイテムを取得
  Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
  // 詳細画面を作成
//  ItemDetailViewController *detailViewController =
//  [[ItemDetailViewController alloc] initWithNibName:@"ItemDetailViewController"
//                                             bundle:nil];
  ItemDetailViewController *detailViewController
  = [[ItemDetailViewController alloc] initWithItem:item
                                  indexPathForItem:indexPath
                                          delegate:self];
  // 詳細画面を設定
//  [detailViewController setDetailItem:item];
//  [detailViewController setIndexPathForItem:indexPath];
//  [detailViewController setDelegate:self];
//  [detailViewController setIsNewItem:NO];
  // 詳細画面をプッシュ
  [self.navigationController pushViewController:detailViewController
                                       animated:NO];
}

/**
 * @brief  詳細画面を終了させる前の処理
 *
 * @param sender      詳細画面
 * @param indexPath   詳細を表示したセルの位置
 * @param updateditem 更新されたアイテム
 */
-(void)dismissDetailView:(id)sender
               indexPath:(NSIndexPath *)indexPath
             updatedItem:(Item *)updateditem
               isNewItem:(BOOL)isNewItem
{
  Item *item;
  if (isNewItem) {
    item = [CoreDataController newItemObject];
  } else {
    item = [self.fetchedResultsController objectAtIndexPath:indexPath];
  }
  item = updateditem;
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
  Item *item                 = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  // タイトル
  cell.titleLabel.text       = item.title;
  
  // 状態
  [cell updateCheckBox:item.state.boolValue];

  // リマインダー
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat       = @"yyyy/MM/dd";
  cell.reminderLabel.text    = [formatter stringFromDate:item.reminder];

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
  if ([self.selectedTagString isEqualToString:@"all"])
  {                             // 全タグ表示中なら
    [CoreDataController insertNewItem:itemString
                                 tags:nil
                             reminder:[NSDate date]]; // タグなしで追加して終了
  }
  else                          // あるタグを表示中なら
  {
    Tag *tag = [[Tag alloc] initWithEntity:[CoreDataController entityDescriptionForName:@"Tag"]
            insertIntoManagedObjectContext:nil];
    tag.title = self.selectedTagString;
    NSSet *tags = [NSSet setWithObject:tag];
    [CoreDataController insertNewItem:itemString
                                 tags:tags
                             reminder:[NSDate date]]; // 新しいアイテムを追加
  }
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
  }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
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
