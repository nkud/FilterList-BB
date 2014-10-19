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
#import "InputTagViewController.h"

#import "Configure.h"

#define kHeightForTagCell 44

#pragma mark -

@interface TagViewController () {
  
}

- (void)configureTagCell:(TagCell *)cell
          atIndexPath:(NSIndexPath *)indexPath;

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

/**
 * @brief  ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  LOG(@"タグビューがロードされた後の処理");
  [super viewDidLoad];
  
  // タイトルを設定
  [self configureTitleWithString:TAG_LIST_TITLE
                        subTitle:@"mini title"];
  self.titleLabel.textColor = TAG_COLOR;
  
  // 使用するセルを登録
  [self.tableView registerNib:[UINib nibWithNibName:@"TagCell"
                                             bundle:nil]
       forCellReuseIdentifier:TagModeCellIdentifier];

  // 編集・追加ボタンを追加
  self.navigationItem.leftBarButtonItem = [self newEditTableButton];
  self.navigationItem.rightBarButtonItem = [self newInsertObjectButton];
}

-(void)didTappedEditTableButton
{
  [self toEdit:self];
}
-(void)didTappedInsertObjectButton
{
  [self toAdd:self];
}

#pragma mark - 遷移
-(void)viewWillAppear:(BOOL)animated
{
  NSIndexPath *indexForAllItems = [NSIndexPath indexPathForRow:0 inSection:0];
  TagCell *cell = (TagCell *)[self.tableView cellForRowAtIndexPath:indexForAllItems];
  [self configureTagCell:cell atIndexPath:indexForAllItems];
}

#pragma mark - 新規入力

/**
 *  @brief 新規入力を開始する
 *
 *  @param sender センダー
 */
-(void)toAdd:(id)sender
{
  // 新規入力画面をプッシュ
  NSString *inputTagNibName = @"InputTagViewController";
  
  // タグ入力画面
  InputTagViewController *inputTagViewController =
  [[InputTagViewController alloc] initWithNibName:inputTagNibName
                                           bundle:nil];
  
  // デリゲートを設定する
  inputTagViewController.delegate = self;
  
  // プッシュする
  [self.navigationController pushViewController:inputTagViewController
                                       animated:YES];
}
#pragma mark - ユーティリティ

-(BOOL)isCellForAllItemsAtIndexPath:(NSIndexPath *)indexPath
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

-(NSInteger)heightForTagCell
{
  return kHeightForTagCell;
}

#pragma mark - テーブルビュー

/**
 *  @brief タグが選択された時の処理
 *
 *  @param tableView tableView description
 *  @param indexPath 選択された場所
 */
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSIndexPath *indexPathInTableView = indexPath;
  LOG(@"タグセルが選択された");
  if ([self isCellForAllItemsAtIndexPath:indexPathInTableView]) {
    [self.delegate didSelectTag:nil];
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
  if ([self isCellForAllItemsAtIndexPath:indexPath]) {
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
  return [sectionInfo numberOfObjects] + 1;
}

/**
 * @brief テーブルのセルを表示する
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // セルを作成する
  TagCell *cell = [tableView dequeueReusableCellWithIdentifier:TagModeCellIdentifier];
  
  // セルを設定
  [self configureTagCell:cell
          atIndexPath:indexPath];
  
  return cell;
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
  if ([self isCellForAllItemsAtIndexPath:indexPath])
  {
    // 全アイテム表示用タグの設定
    cell.labelForTitle.text = @"all items";
    cell.labelForOverDueItemsSize.text = @"";
    itemCountString = [NSString stringWithFormat:@"%ld", (long)[CoreDataController countItems]];
  } else
  {
    // 通常のタグの設定
    indexPath = [self mapIndexPathToFetchResultsController:indexPath];
    tag = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.labelForTitle.text = tag.title;
    NSInteger overDueItemsSizeForTag = [[self overDueItemsForTag:tag] count];
    LOG(@"%ld", (long)overDueItemsSizeForTag);
    cell.labelForOverDueItemsSize.text = [NSString stringWithFormat:@"%lu", (unsigned long)overDueItemsSizeForTag];
    itemCountString = [NSString stringWithFormat:@"%lu", (unsigned long)[tag.items count]];
  }
  cell.labelForItemSize.text = itemCountString;
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
  LOG(@"アクセサリーをタップ");
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
  return [self heightForTagCell];
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
  [self.tableView reloadData];
}

#pragma mark - コンテンツの更新

/**
 * @brief  コンテンツを更新する前処理
 *
 * @param controller リザルトコントローラー
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  LOG(@"コンテキストを更新する前処理");
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
  LOG(@"コンテキストを更新");
  switch(type) {
    case NSFetchedResultsChangeInsert:
      LOG(@"挿入");
      [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;

    case NSFetchedResultsChangeDelete:
      LOG(@"削除");
      [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                    withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeMove: // by ios8
      LOG(@"移動");
      break;
    case NSFetchedResultsChangeUpdate:
      LOG(@"更新");
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
  indexPath = [self mapIndexPathFromFetchResultsController:indexPath];
  newIndexPath = [self mapIndexPathFromFetchResultsController:newIndexPath];
  LOG(@"コンテキストを更新");
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
      
      // 他のタグのアイテム数も変更するように更新
      // TODO: これだと一瞬で切り替わってしまう
      [self.tableView reloadData];
      //      Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
      //      NSSet *tags = item.tags; // アイテムに設定されているタグのセットを取得して
      //      for (Tag *tag in tags) { // そのセットそれぞれに対して
      //        if ([tag.items count] == 0) { // タグの関連付けがそのアイテムのみだった場合
      //          [app.managedObjectContext deleteObject:tag]; // そのタグも削除する
      //        }
      //      }
      break;
    }

    case NSFetchedResultsChangeUpdate:
      LOG(@"更新");
//      [self configureTagCell:(TagCell *)[tableView cellForRowAtIndexPath:indexPath]
//              atIndexPath:indexPath];                                // これであってる？？

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
 *  コンテンツが更新された後処理
 *
 *  @param controller リザルトコントローラー
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  LOG(@"コンテキストを更新した後の処理");
  // In the simplest, most efficient, case, reload the table view.
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

#pragma mark - デリゲート

/**
 * @brief  タグを保存する
 *
 * @param tagTitle タグのタイトル
 */
-(void)saveTags:(NSString *)tagTitle
{
  // 文字列が空欄なら終了
  if ([tagTitle isEqual:@""]) {
    return;
  }

  // 新規タグを保存
  [CoreDataController insertNewTag:tagTitle];
}


@end
