//
//  MenuView.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "TagViewController.h"
#import "Header.h"
#import "TagCell.h"
#import "Tag.h"
#import "CoreDataController.h"

#import "InputHeaderCell.h"

#import "TagDetailViewController.h"

#import "Configure.h"

//#define kHeightForTagCell 44

#pragma mark -

static NSString *kInputHeaderCellID = @"InputHeaderCell";
static NSString *kTagCellID = @"TagCell";

static NSString *kInputFieldPlaceholder = @"new tag";

@interface TagViewController ()
@end

@implementation TagViewController

#pragma mark - 初期化

/**
 * @brief  パラメータを初期化する
 */
-(void)initParameter
{
  self.navbarThemeColor = TAG_COLOR;
}

/**
 * @brief  ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // パラメータを初期化する
  [self initParameter];
  
  // ナビバーのタイトルを設定する
  [self configureTitleWithString:TAG_LIST_TITLE
                        subTitle:nil
                        subColor:TAG_COLOR];
  self.titleLabel.textColor = TAG_COLOR;
  
  // 入力用セルを登録する
//  [self.tableView registerClass:[UITableViewCell class]
//         forCellReuseIdentifier:TagModeCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:kInputHeaderCellID
                                             bundle:nil]
       forCellReuseIdentifier:kInputHeaderCellID];

  // 編集・追加ボタンを追加する
  self.navigationItem.leftBarButtonItem = [self newEditTableButton];
  self.navigationItem.leftBarButtonItem.tintColor = TAG_COLOR;
  self.navigationItem.rightBarButtonItem = [self newInsertObjectButton];
  self.navigationItem.rightBarButtonItem.tintColor = TAG_COLOR;
  
  // テーブルの設定をする。
  // テーブルの編集時複数選択を不可能にする。
  // 背景色を設定する。
  // フレームのサイズをアイテムリストの出っ張りの分だけ細くする。
  self.tableView.allowsMultipleSelectionDuringEditing = NO;
  self.tableView.backgroundColor = TAG_BG_COLOR;
  CGRect frame = self.tableView.frame;
  frame.size.width -= ITEM_LIST_REMAIN_MARGIN;
  self.tableView.frame = frame;
}

#pragma mark - 遷移



/**
 * @brief  編集ボタンがタップされた時の処理
 */
-(void)didTappedEditTableButton
{
//  [super didTappedEditTableButton];

  // 完全に開閉する
  if (self.tableView.isEditing) {
    [self.delegateForList listDidEditMode];
  } else {
    [self.delegateForList listWillEditMode];
  }
  
  [self toEdit:self];
  
  // タブバーの時は、編集タブバーを開かない
  [self hideEditTabBar:YES];
  
  [self updateTableView];
}

/**
 * @brief  挿入ボタンがタップされた時の処理
 */
-(void)didTappedInsertObjectButton
{
  [super didTappedInsertObjectButton];
  
  // タグの挿入へ遷移する。
  [self toAdd:self];
}

/**
 * @brief  ビューが表示する前処理
 *
 * @param animated アニメーション
 */
-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // タグモードの時のみタブバーを開く
  if ([self.delegateForList isTopViewController:self]) {
    [self.delegateForList openTabBar];
  }
}

/**
 * @brief  ビューの表示後の処理
 *
 * @param animated アニメーション
 */
-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // タグモードの時のみ
  if ([self.delegateForList isTopViewController:self] && self.tableView.isEditing == NO) {
    [self.delegateForList listDidEditMode];
  }
}

#pragma mark - キーボード操作

/**
 * @brief  インプットセルによるキーボードを閉じる
 */
-(void)dismissInputKeyboard
{
  // インプットセルの位置を取得して、
  // キーボードを閉じる。
  NSIndexPath *inputCellIndexPath = INDEX(0, 0);
  InputHeaderCell *cell = (InputHeaderCell *)[self.tableView cellForRowAtIndexPath:inputCellIndexPath];
  [cell.inputField resignFirstResponder];
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

#pragma mark - 新規入力

/**
 *  @brief 新規入力を開始する
 *
 *  @param sender センダー
 */
-(void)toAdd:(id)sender
{
  [self.delegateForList listWillEditMode];
  
  // 詳細画面を作成する
  TagDetailViewController *controller = [[TagDetailViewController alloc] initWithTitle:nil
                                                                             indexPath:nil
                                                                              delegate:self];
  controller.navigationController = self.navigationController;
  
  // プッシュする
  [self.navigationController pushViewController:controller
                                       animated:YES];
  [self.delegateForList closeTabBar];
}

#pragma mark - ユーティリティ

/**
 * @brief  全アイテム選択用セルかどうかを評価する
 *
 * @param indexPath 位置
 *
 * @return 真偽値
 */
-(BOOL)isCellForAllItemsAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 1 && indexPath.section == 0 ) {
    return YES;
  } else {
    return NO;
  }
}

/**
 * @brief  入力用セルかどうかを評価する
 *
 * @param indexPath 位置
 *
 * @return 真偽値
 */
-(BOOL)isCellForInputAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 0 && indexPath.section == 0 ) {
    return YES;
  } else {
    return NO;
  }
}

/**
 * @brief  コントローラー位置 -> テーブル位置
 *
 * @param indexPath コントローラ位置
 *
 * @return テーブル位置
 */
- (NSIndexPath *)mapIndexPathFromFetchResultsController:(NSIndexPath *)indexPath
{
  indexPath = INDEX(indexPath.row + 2,
                    indexPath.section);
  return indexPath;
}

/**
 * @brief  テーブル位置 -> コントローラ位置
 *
 * @param indexPath テーブル位置
 *
 * @return コントローラ位置
 */
- (NSIndexPath *)mapIndexPathToFetchResultsController:(NSIndexPath *)indexPath
{
  indexPath = INDEX(indexPath.row - 2,
                      indexPath.section);
  return indexPath;
}

#pragma mark - テーブルビュー

/**
 * @brief  スクロール開始時の処理
 *
 * @param scrollView スクロールビュー
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  // スクロール時には、
  // キーボードを閉じる。
  [self dismissInputKeyboard];
}

/**
 * @brief  位置が移動可能か評価する
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 *
 * @return 真偽値
 */
-(BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // 通常セル以外は移動不可能にする。
  if ([self isCellForInputAtIndexPath:indexPath] || [self isCellForAllItemsAtIndexPath:indexPath]) {
    return NO;
  }
  return YES;
}

/**
 * @brief  セルの移動先を処理
 *
 * @param tableView                    テーブル
 * @param sourceIndexPath              元位置
 * @param proposedDestinationIndexPath 提案位置
 *
 * @return 移動先位置
 */
-(NSIndexPath *)tableView:(UITableView *)tableView
targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
  // 上位セルを固定して、
  // その位置にくると、一番上に移動するようにする。
  if ([self isCellForAllItemsAtIndexPath:proposedDestinationIndexPath] || [self isCellForInputAtIndexPath:proposedDestinationIndexPath]) {
    return INDEX(2, 0);
  }
  return proposedDestinationIndexPath;
}

//-(void)selectAllRows:(id)sender
//{
//  LOG(@"全選択");
//  NSArray *objects = [self.fetchedResultsController fetchedObjects];
//  for (NSManagedObject *obj in objects) {
//    NSIndexPath *indexPathInController = [self.fetchedResultsController indexPathForObject:obj];
//    NSIndexPath *indexPathInTable = [self mapIndexPathFromFetchResultsController:indexPathInController];
//    [self.tableView selectRowAtIndexPath:indexPathInTable
//                                animated:NO
//                          scrollPosition:UITableViewScrollPositionNone];
//  }
//  [self updateEditTabBar];
//}


/**
 *  @brief タグが選択された時の処理
 *
 *  @param tableView tableView description
 *  @param indexPath 選択された場所
 */
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  // キーボードを閉じる
  [self dismissInputKeyboard];
  
  [super tableView:tableView didSelectRowAtIndexPath:indexPath];
  if (tableView.isEditing) {
    return;
  }
  NSIndexPath *indexPathInTableView = indexPath;
  LOG(@"タグセルが選択された");
  if ([self isCellForAllItemsAtIndexPath:indexPathInTableView]) {
    [self.delegate didSelectTag:nil];
  } else if([self isCellForInputAtIndexPath:indexPathInTableView]) {
    ;
  } else {
    // 選択された位置のタグを取得して
    NSIndexPath *indexPathInController = [self mapIndexPathToFetchResultsController:indexPathInTableView];
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
    
    // 選択されたタグを渡す
    [self.delegate didSelectTag:tag];
  }

  // タグの選択状態を解除する。
  /// ここは、戻ってくるまで解除しないようにしてもいいかも。
  [tableView deselectRowAtIndexPath:indexPathInTableView
                           animated:YES];
}

#pragma mark 編集モード

/**
 * @brief  編集モード切り替え
 *
 * @param sender センダー
 */
-(void)toEdit:(id)sender
{
  if (self.tableView.isEditing) {
    [self.tableView setEditing:false
                      animated:YES];
  } else {
    [self.tableView setEditing:true
                      animated:YES];
  }
}
/**
 *  @brief テーブル編集の可否
 *
 *  @param tableView テーブルビュー
 *  @param indexPath インデックス
 *
 *  @return 可否
 */
-(BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
  // タグセクションのみ
  // 編集可能にする
  if ([self isCellForAllItemsAtIndexPath:indexPath] || [self isCellForInputAtIndexPath:indexPath]) {
    return NO;
  }
  return YES;
}

/**
 * @brief  編集時の処理
 *
 * @param tableView    テーブルビュー
 * @param editingStyle 編集状態
 * @param indexPath    位置
 */
-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (editingStyle) {
    case UITableViewCellEditingStyleDelete:
    {
      // コントローラ位置を取得して、タグを取得し、
      // 関連づいているアイテムセット、順番を取得する。
      NSIndexPath *indexInController = [self mapIndexPathToFetchResultsController:indexPath];
      Tag *deleteTag = [self.fetchedResultsController objectAtIndexPath:indexInController];
      NSSet *itemset = [deleteTag.items mutableCopy];
      NSInteger deleteTagOrder = deleteTag.order.integerValue;
      
      // 今から削除するタグをデリゲートに報告する
      [self.delegate willDeleteTag:deleteTag];
      
      // アイテムの関連を削除する
      for (Item *item in itemset) {
        item.tag = nil;
      }
      
      // タグを削除する
      [[CoreDataController managedObjectContext] deleteObject:deleteTag];
      
      // タグの順序を整理する
      NSArray *tags = [self.fetchedResultsController fetchedObjects];
      NSInteger newOrder;
      for (Tag *tag in tags) {
        NSInteger order = tag.order.integerValue;
        if (order > deleteTagOrder) {
          newOrder = order - 1;
          [tag setValue:@(newOrder)
                 forKey:@"order"];
        }
      }
      [CoreDataController saveContext];
      break;
    }
    default:
      break;
  }
}

-(void)deleteAllSelectedRows:(id)sender
{
  LOG(@"選択セルのみ削除");
  for (NSIndexPath *indexPathInTableView in self.tableView.indexPathsForSelectedRows) {
    NSIndexPath *indexPathInController = [self mapIndexPathToFetchResultsController:indexPathInTableView];
    NSManagedObject *item = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
    [[self.fetchedResultsController managedObjectContext] deleteObject:item];
  }
}

#pragma mark ビューの設定

/**
 * @brief セクション数を返す
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [[self.fetchedResultsController sections] count];
}

/**
 * @brief アイテム数を返す
 */
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  // 入力セルと、全アイテム選択セルの分だけ増やす。
  id <NSFetchedResultsSectionInfo> sectionInfo
  = [[self.fetchedResultsController sections] objectAtIndex:section];
  return [sectionInfo numberOfObjects] + 2;
}

/**
 * @brief テーブルのセルを表示する
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isCellForInputAtIndexPath:indexPath])
  {
    // TODO: 入力セル用のコンフィグメソッドを作成する
    InputHeaderCell *inputCell = [tableView dequeueReusableCellWithIdentifier:kInputHeaderCellID
                                                                 forIndexPath:indexPath];
    inputCell.inputField.placeholder = kInputFieldPlaceholder;
    inputCell.delegate = self;
    inputCell.inputField.delegate = self;
    return inputCell;
  }
  // 通常のセルを作成する
//  TagCell *cell = [tableView dequeueReusableCellWithIdentifier:TagModeCellIdentifier
//                                                  forIndexPath:indexPath];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTagCellID];

  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier:kTagCellID];
  }

  // セルを設定する
  [self configureTagCell:cell
          atIndexPath:indexPath];
  
  return cell;
}

-(void)didInputtedNewItem:(NSString *)titleForItem
{
  // 新しいアイテムを挿入する
  [CoreDataController insertNewTag:titleForItem];
  
  // インスタントメッセージを表示する
  [self instantMessage:@"Saved"
                 color:nil];
}

#pragma mark セル関係

/**
 * @brief  セルを設定する
 *
 * @param cell      設定するセル
 * @param indexPath セルの位置
 */
- (void)configureTagCell:(UITableViewCell *)cell
             atIndexPath:(NSIndexPath *)indexPath
{
  Tag *tag;
  NSString *itemCountString = @"";
  NSString *titleString;
  UITableView *table = self.tableView;
  
  // セルの背景色を設定する
  cell.backgroundColor = TAG_BG_COLOR;
  
  if ([self isCellForAllItemsAtIndexPath:indexPath])
  {
    // 全アイテム表示用タグの設定
    titleString = @"Inbox";
    
    // 未完了のアイテム数を取得する
    itemCountString = [NSString stringWithFormat:@"%ld", (long)[CoreDataController countUncompletedItems]];
  } else if([self isCellForInputAtIndexPath:indexPath]) {
    return;
  }
  else
  {
    // 通常のタグの設定
    // タグを取得して、情報を表示する
    indexPath = [self mapIndexPathToFetchResultsController:indexPath];
    tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    titleString = tag.title;
    if (table.isEditing == NO) {
      itemCountString = [NSString stringWithFormat:@"%lu", (unsigned long)[CoreDataController countUncompletedItemsWithTags:[NSSet setWithObjects:tag, nil]]];
    }
  }
  cell.textLabel.text = titleString;
  cell.detailTextLabel.text = itemCountString;

  cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
}

/**
 * @brief  アクセサリーをタップした時の処理
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 */
-(void)tableView:(UITableView *)tableView
accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
  NSIndexPath *indexPathInController = [self mapIndexPathToFetchResultsController:indexPath];
  Tag *tag = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
  TagDetailViewController *controller
  = [[TagDetailViewController alloc] initWithTitle:tag.title
                                         indexPath:indexPathInController
                                          delegate:self];
  
  controller.navigationController = self.navigationController;
  
  LOG(@"タグ詳細画面をプッシュする");
  [self.navigationController pushViewController:controller
                                       animated:YES];
  LOG(@"タブバーを閉じる");
  [self.delegateForList closeTabBar];
}

// TODO: tag で処理
- (NSSet *)overDueItemsForTag:(Tag *)tag
{
  NSMutableSet *items = [[NSMutableSet alloc] init];
  for (Item *item in tag.items) {
    if ([item isOverDue] && item.state.intValue == 0) {
      [items addObject:item];
    }
  }
  return items;
}

/**
 * @brief  セルの高さ
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 *
 * @return セルの高さ
 */
//-(CGFloat)tableView:(UITableView *)tableView
//heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//  return CGRectGetHeight([[self.tableView dequeueReusableCellWithIdentifier:kTagCellID] frame]);
//}

#pragma mark 更新

/**
 * @brief  テーブルを更新する
 *
 * @note いらんかも？
 */
- (void)updateTableView
{
  NSArray *visibleCells = [self.tableView visibleCells];
  for (UITableViewCell *cell in visibleCells) {
    [self configureTagCell:cell
               atIndexPath:[self.tableView indexPathForCell:cell]];
  }
}

//- (void)updateVisibleCells {
//  for (UITableViewCell *cell in [self.tableView visibleCells]){
//    [self updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
//  }
//}

/**
 * @brief  セルを移動する
 *
 * @param tableView            テーブルビュー
 * @param sourceIndexPath      前位置
 * @param destinationIndexPath 後位置
 */
-(void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
     toIndexPath:(NSIndexPath *)destinationIndexPath
{
  // コントローラ用の位置に変換する
  NSIndexPath *sourceIndexPathInController = [self mapIndexPathToFetchResultsController:sourceIndexPath];
  NSIndexPath *destinationIndexPathInController = [self mapIndexPathToFetchResultsController:destinationIndexPath];
  
  NSInteger minRowIdx, maxRowIdx;
  BOOL isMoveDirectionSmallToLarge;
  if(sourceIndexPathInController.row == destinationIndexPathInController.row){
    return;
  }else if(sourceIndexPathInController.row < destinationIndexPathInController.row){
    minRowIdx = sourceIndexPathInController.row;
    maxRowIdx = destinationIndexPathInController.row;
    isMoveDirectionSmallToLarge = YES;
  }else{
    minRowIdx = destinationIndexPathInController.row;
    maxRowIdx = sourceIndexPathInController.row;
    isMoveDirectionSmallToLarge = NO;
  }
  for(NSInteger i = minRowIdx; i <= maxRowIdx; i++){
    NSIndexPath *itIndexPath = INDEX(i, 0);
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:itIndexPath];
    NSNumber *displayOrder = tag.order;
    NSInteger newOrder;
    
    // 移動前位置なら、移動先に移動。
    // その他の位置なら、１つずらす。
    if(i == sourceIndexPathInController.row){
      newOrder = destinationIndexPathInController.row;
    }else if(isMoveDirectionSmallToLarge){
      newOrder = displayOrder.integerValue - 1;
    }else{
      newOrder = displayOrder.integerValue + 1;
    }
    LOG(@"%ld, %ld, %ld", (long)i, (long)displayOrder.integerValue, (long)newOrder);
    tag.order = [NSNumber numberWithInteger:newOrder];
  }
}

#pragma mark - コンテンツの更新

/**
 * @brief  コンテンツを更新する前処理
 *
 * @param controller リザルトコントローラー
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  LOG(@"テーブルビューのアップデートを開始する");
  [self.tableView beginUpdates];
}

/**
 * @brief  セクションの変更処理
 *
 * @param controller   コントローラー
 * @param sectionInfo  セクション情報
 * @param sectionIndex セクション位置
 * @param type         タイプ？？
 */
- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
  switch(type) {
    case NSFetchedResultsChangeInsert:
      LOG(@"セクションを挿入する");
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeDelete:
      LOG(@"セクションを削除する");
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeMove: // by ios8
      LOG(@"セクションを移動する");
      break;
    case NSFetchedResultsChangeUpdate:
      LOG(@"セクションを更新する");
      break;
  }
}

/**
 * @brief  オブジェクトの変更処理
 *
 * @param controller   コントローラー
 * @param anObject     オブジェクト
 * @param indexPath    位置
 * @param type         タイプ？？
 * @param newIndexPath 新しい位置
 */
- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
  NSIndexPath *indexPathInTableView = [self mapIndexPathFromFetchResultsController:indexPath];
  NSIndexPath *newIndexPathInTableView = [self mapIndexPathFromFetchResultsController:newIndexPath];
  UITableView *tableView = self.tableView;
  switch(type) {
    case NSFetchedResultsChangeInsert:
      LOG(@"セルを挿入する");
      [tableView insertRowsAtIndexPaths:@[newIndexPathInTableView]
                       withRowAnimation:UITableViewRowAnimationLeft];
      break;
    case NSFetchedResultsChangeDelete:
    {
      LOG(@"セルを削除する");
      [tableView deleteRowsAtIndexPaths:@[indexPathInTableView]
                       withRowAnimation:UITableViewRowAnimationFade];
      break;
    }
    case NSFetchedResultsChangeUpdate:
      LOG(@"セルを更新する");
      // 以下ではアニメーションがおかしくなる。
      // [tableView reloadRowsAtIndexPaths:@[indexPathInTableView]
      //                  withRowAnimation:UITableViewRowAnimationAutomatic];
      
      [self configureTagCell:(TagCell *)[tableView cellForRowAtIndexPath:indexPathInTableView]
                 atIndexPath:indexPathInTableView];
      break;
    case NSFetchedResultsChangeMove:
      break;
  }
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 */

/**
 *  コンテンツが更新された後処理
 *
 *  @param controller リザルトコントローラー
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  // In the simplest, most efficient, case, reload the table view.
  LOG(@"テーブルビューのアップデートを終了する");
  [CoreDataController saveContext];
  [self.tableView endUpdates];
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

/**
 * @brief  詳細ビューを削除する前処理
 *
 * @param title     入力されたタイトル
 * @param indexPath 位置
 * @param isNewTag  新規評価
 */
-(void)dismissDetailView:(NSString *)title
               indexPath:(NSIndexPath *)indexPath
                isNewTag:(BOOL)isNewTag
{
  // 空欄なら終了する
  if ([title isEqualToString:@""]) {
    return;
  }
  NSIndexPath *indexPathInController = indexPath;
  Tag *tag;
  if (isNewTag) {
    [CoreDataController insertNewTag:title];
    return;
  } else {
    tag = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
  }
  tag.title = title;
  
  [CoreDataController saveContext];
}

#pragma mark - デリゲート

/**
 * @brief  タグを保存する
 *
 * @param tagTitle タグのタイトル
 */
-(void)saveTags:(NSString *)tagTitle
{
  // 文字列が空欄なら終了する
  if ([tagTitle isEqual:@""]) {
    return;
  }

  // 新規タグを保存する
  [CoreDataController insertNewTag:tagTitle];
}


@end
