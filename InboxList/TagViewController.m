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

@interface TagViewController () {
  
}

@end

@implementation TagViewController

#pragma mark - 初期化

/**
 * @brief この初期化方法は変えたほうがいいかも
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  return self;
}

-(void)initParameter
{
  self.navbarThemeColor = TAG_COLOR;
}

/**
 * @brief  ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  LOG(@"タグビューがロードされた後の処理");
  [super viewDidLoad];
  
  [self initParameter];
  
  self.tableView.allowsMultipleSelectionDuringEditing = NO;
  
  // タイトルを設定
  [self configureTitleWithString:TAG_LIST_TITLE
                        subTitle:nil
                        subColor:TAG_COLOR];
  self.titleLabel.textColor = TAG_COLOR;
  
  // 使用するセルを登録
  [self.tableView registerClass:[TagCell class]
         forCellReuseIdentifier:TagModeCellIdentifier];
  [self.tableView registerNib:[UINib nibWithNibName:kInputHeaderCellID
                                             bundle:nil]
       forCellReuseIdentifier:kInputHeaderCellID];

  // 編集・追加ボタンを追加
  self.navigationItem.leftBarButtonItem = [self newEditTableButton];
  self.navigationItem.leftBarButtonItem.tintColor = TAG_COLOR;
  self.navigationItem.rightBarButtonItem = [self newInsertObjectButton];
  self.navigationItem.rightBarButtonItem.tintColor = TAG_COLOR;
  
  // テーブルの設定
  self.tableView.backgroundColor = TAG_BG_COLOR;
  CGRect frame = self.tableView.frame;
  frame.size.width -= ITEM_LIST_REMAIN_MARGIN;
  self.tableView.frame = frame;
}

-(void)didTappedEditTableButton
{
  // 完全に開閉する
  if (self.tableView.isEditing) {
    [self.delegateForList listDidEditMode];
  } else {
    [self.delegateForList listWillEditMode];
  }
  
  [super didTappedEditTableButton];
  [self toEdit:self];
}
-(void)didTappedInsertObjectButton
{
  [super didTappedInsertObjectButton];
  [self toAdd:self];
}

#pragma mark - 遷移
-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
  // タグモードの時のみタブバーを開く
  if ([self.delegateForList isTopViewController:self] && self.tableView.isEditing == NO) {
    [self.delegateForList openTabBar];
  }
}

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // タグモードの時のみ
  if ([self.delegateForList isTopViewController:self] && self.tableView.isEditing == NO) {
    [self.delegateForList listDidEditMode];
  }
}

-(void)dismissInputKeyboard
{
  // キーボードを閉じる
  NSIndexPath *inputIndexPath = [NSIndexPath indexPathForRow:0
                                                   inSection:0];
  InputHeaderCell *cell = (InputHeaderCell *)[self.tableView cellForRowAtIndexPath:inputIndexPath];
  [cell.inputField resignFirstResponder];
}

#pragma mark - 新規入力
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
}/**
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

-(BOOL)isCellForAllItemsAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == 1 && indexPath.section == 0 ) {
    return YES;
  } else {
    return NO;
  }
}

-(BOOL)isCellForInputAtIndexPath:(NSIndexPath *)indexPath
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
    indexPath = [NSIndexPath indexPathForRow:indexPath.row + 2
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
    indexPath = [NSIndexPath indexPathForRow:indexPath.row - 2
                                   inSection:indexPath.section];
  
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
  // キーボードを閉じる
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
  // 上位セルを固定
  if ([self isCellForAllItemsAtIndexPath:proposedDestinationIndexPath] || [self isCellForInputAtIndexPath:proposedDestinationIndexPath]) {
    return sourceIndexPath;
  }
  return proposedDestinationIndexPath;
}

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
  LOG(@"タグセルの選択を解除");
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
  if ([self isCellForAllItemsAtIndexPath:indexPath] || [self isCellForInputAtIndexPath:indexPath]) {
    return NO;                  // 編集不可
  }                             // タグセクションなら
  return YES;                   // 編集可
}

-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (editingStyle) {
    case UITableViewCellEditingStyleDelete: // 削除
    {
      LOG(@"タグを削除");
      Tag *tag = [self.fetchedResultsController objectAtIndexPath:[self mapIndexPathToFetchResultsController:indexPath]];
      LOG(@"関連アイテム：%@", tag.items);
      LOG(@"アイテムを削除");
      for (Item *item in tag.items) {
        [[CoreDataController managedObjectContext] deleteObject:item];
      }
      
      LOG(@"タグを削除");
      [[CoreDataController managedObjectContext] deleteObject:tag];
      LOG(@"削除されるオブジェクト数：%lu", (unsigned long)[[[CoreDataController managedObjectContext] deletedObjects] count]);
      
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
    InputHeaderCell *inputCell = [tableView dequeueReusableCellWithIdentifier:kInputHeaderCellID];
    inputCell.inputField.placeholder = @"new Tag";
    inputCell.delegate = self;
    inputCell.inputField.delegate = self;
    return inputCell;
  }
  // セルを作成する
  TagCell *cell = [tableView dequeueReusableCellWithIdentifier:TagModeCellIdentifier];
  
  // セルを設定
  [self configureTagCell:cell
          atIndexPath:indexPath];
  
  return cell;
}

-(void)didInputtedNewItem:(NSString *)titleForItem
{
  LOG(@"新しいアイテムを挿入する");
  [CoreDataController insertNewTag:titleForItem];
  
  LOG(@"インスタントメッセージを表示する");
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
- (void)configureTagCell:(TagCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
  Tag *tag;
  NSString *itemCountString;
  
  LOG(@"セルの背景色を設定する");
  cell.backgroundColor = TAG_BG_COLOR;
  
  if ([self isCellForAllItemsAtIndexPath:indexPath])
  {
    // 全アイテム表示用タグの設定
    cell.titleLabel.text = @"Inbox";
    
    LOG(@"未完了アイテム数を取得する");
    itemCountString = [NSString stringWithFormat:@"%ld", (long)[CoreDataController countUncompletedItems]];
  } else if([self isCellForInputAtIndexPath:indexPath]) {
    return;
  }
  else
  {
    // 通常のタグの設定
    indexPath = [self mapIndexPathToFetchResultsController:indexPath];
    tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = tag.title;
    LOG(@"タグに関連づいた未完了アイテム数を取得する");
    itemCountString = [NSString stringWithFormat:@"%lu", (unsigned long)[CoreDataController countUncompletedItemsWithTags:[NSSet setWithObjects:tag, nil]]];
  }
  cell.itemSizeLabel.text = itemCountString;
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
-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return CGRectGetHeight([[self.tableView dequeueReusableCellWithIdentifier:kTagCellID] frame]);
}

#pragma mark 更新

/**
 * @brief  テーブルを更新する
 *
 * @note いらんかも？
 */
- (void)updateTableView
{
  NSIndexPath *indexForAllItems = [NSIndexPath indexPathForRow:0 inSection:0];
  TagCell *cell = (TagCell *)[self.tableView cellForRowAtIndexPath:indexForAllItems];
  [self configureTagCell:cell atIndexPath:indexForAllItems];
  
  LOG(@"テーブルビューのデータをリロードする");
  [self.tableView reloadData];
}

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
    NSIndexPath *itIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
    NSManagedObject *managedObj = [self.fetchedResultsController objectAtIndexPath:itIndexPath];
    NSNumber *displayOrder = [managedObj valueForKey:@"order"];
    NSInteger newOrder;
    if(i == sourceIndexPathInController.row){
      newOrder = destinationIndexPathInController.row;
    }else if(isMoveDirectionSmallToLarge){
      newOrder = [displayOrder integerValue] - 1;
    }else{
      newOrder = [displayOrder integerValue] + 1;
    }
    LOG(@"%ld, %ld, %ld", (long)i, (long)displayOrder.integerValue, (long)newOrder);
    [managedObj setValue:@(newOrder) forKey:@"order"];
  }
  [CoreDataController saveContext];
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
      
      LOG(@"順序を整理する");
      NSArray *tags = [controller fetchedObjects];
      Tag *deleteTag = [controller objectAtIndexPath:indexPath];
      NSInteger deleteOrder = deleteTag.order.integerValue;
      NSInteger newOrder;
      LOG(@"--------- tag order ---------");
      for (Tag *tag in tags) {
        NSInteger order = tag.order.integerValue;
        if (order > indexPath.row) {
          LOG(@"%ld > %ld", (long)order, (long)deleteOrder);
          newOrder = order - 1;
          [tag setValue:@(newOrder)
                 forKey:@"order"];
        }
        LOG(@"%@: %@", tag.title, tag.order);
      }
      LOG(@"-----------------------------");
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
      LOG(@"セルを移動する");
      [tableView moveRowAtIndexPath:indexPathInTableView
                        toIndexPath:newIndexPathInTableView];
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
