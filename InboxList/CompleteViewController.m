//
//  CompleteViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "CompleteViewController.h"
#import "CoreDataController.h"

#import "CompleteCell.h"

#import "Header.h"
#import "Configure.h"

static NSString *kCompleteCellID = @"CompleteCell";

#pragma mark -

@interface CompleteViewController ()

@end

@implementation CompleteViewController

#pragma mark - 初期化
/**
 * @brief  ビュー読み込み後の処理
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"CompleteCell" bundle:nil]
       forCellReuseIdentifier:kCompleteCellID];
  
  // 編集ボタン
  self.navigationItem.leftBarButtonItem = [self newEditTableButton];
  // Do any additional setup after loading the view.
  
  self.tableView.allowsMultipleSelectionDuringEditing = YES;
  
  // 編集タブ
  UIView *editTabBar = [[UIView alloc] initWithFrame:self.tabBar.frame];
  editTabBar.backgroundColor = [UIColor whiteColor];
  
  UIButton *deleteAllButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [deleteAllButton addTarget:self
                      action:@selector(deleteAllSelectedRows)
            forControlEvents:UIControlEventTouchUpInside];
  deleteAllButton.frame = CGRectMake(0, 0, 100, 30);
  deleteAllButton.backgroundColor = [UIColor redColor];
  deleteAllButton.titleLabel.text = @"Delete";
  [editTabBar addSubview:deleteAllButton];
  
  [self.view addSubview:editTabBar];
}

-(void)deleteAllSelectedRows
{
  LOG(@"全削除");
  for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
    Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [[self.fetchedResultsController managedObjectContext] deleteObject:item];
  }
}

-(void)didTappedEditTableButton
{
  [self toEdit:self];
}

#pragma mark - テーブルビュー
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
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:[self.fetchedResultsController
                           objectAtIndexPath:indexPath]];
    [CoreDataController saveContext];
  }
}/**
 *  @brief 編集
 *
 *  @param sender センダー
 */
- (void)toEdit:(id)sender
{
  if (self.tableView.isEditing) {
    LOG(@"編集モード終了");
    [self.tableView setEditing:false
                      animated:YES];
    [self.delegateForList openTabBar];
  } else {
    LOG(@"編集モード開始");
    [self.tableView setEditing:true
                      animated:YES];
    [self.delegateForList closeTabBar];
  }
}

/**
 * @brief  セルが選択された時の処理
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 */
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  LOG(@"完了リストセルが選択された");
}

-(void)updateTableView
{
  LOG(@"ナビゲーションバーを更新");
  id <NSFetchedResultsSectionInfo> sectionInfo
  = [self.fetchedResultsController sections][0];
  [self configureTitleWithString:@"COMPLETE"
                        subTitle:[NSString stringWithFormat:@"%ld items are completed.",
                                  (long)[sectionInfo numberOfObjects]]];
  self.titleLabel.textColor = COMPLETE_COLOR;
  
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
 *  @brief セクション内のセル数を返す
 *
 *  @param tableView テーブルビュー
 *  @param section   セクション
 *
 *  @return セル数
 */
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  id <NSFetchedResultsSectionInfo> sectionInfo
  = [self.fetchedResultsController sections][section];
  return [sectionInfo numberOfObjects];
}

/**
 * @brief  セルを返す
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 *
 * @return インスタンス
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  CompleteCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCompleteCellID];
  [self configureCompleteCell:cell
       atIndexPathInTableView:indexPath];
  return cell;
}
#pragma mark セルの設定
/**
 * @brief  セルを設定
 *
 * @param cell                 セル
 * @param indexPathInTableView 位置
 */
-(void)configureCompleteCell:(CompleteCell *)cell
      atIndexPathInTableView:(NSIndexPath *)indexPathInTableView
{
  Item *item = [self.fetchedResultsController objectAtIndexPath:indexPathInTableView];
  cell.titleLabel.text = item.title;
  cell.tagLabel.text = item.tag.title;
  [cell updateCheckBox:item.state];
  
  // 完了日を表示
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat = @"MM/dd/hh-mm-ss";
  cell.completionDateLabel.text = [formatter stringFromDate:item.completionDate];
  
  // TODO: 親リストを継承させる
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
  //  static bool flag = false;
  static CompleteCell *selected_cell = nil;
  
  switch (sender.state) {
    case UIGestureRecognizerStateBegan:
    {
      LOG(@"チェックボックスのタッチ開始");
      CGPoint point = [sender locationInView:self.tableView];
      NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
      
      // その位置のセルのデータをモデルから取得する
      CompleteCell *cell = (CompleteCell *)[self.tableView cellForRowAtIndexPath:indexPath];
      
      selected_cell = cell;
      [selected_cell setUnChecked];
    }
      break;
      
    case UIGestureRecognizerStateEnded:
    {
      LOG(@"チェックボックスのタッチ終了");
      CGPoint point = [sender locationInView:self.tableView];
      NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
      
      // その位置のセルのデータをモデルから取得する
      
      LOG(@"モデルを取得");
      Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
      CompleteCell *cell = (CompleteCell *)[self.tableView cellForRowAtIndexPath:indexPath];
      
      if (selected_cell == cell) {
        // チェックを外す
        item.state = [NSNumber numberWithBool:false];
        [item setIncomplete];
        [CoreDataController saveContext];
      } else {
        [selected_cell setChecked];
      }
      [CoreDataController saveContext];
    }
      break;
      
    default:
      break;
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
      [self configureCompleteCell:(CompleteCell *)[tableView cellForRowAtIndexPath:indexPath]
           atIndexPathInTableView:indexPath];
      
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

/**
 *  @brief コンテンツが更新された後処理
 *
 *  @param controller リザルトコントローラー
 */
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
  LOG(@"アイテムビューが更新されたあとの処理");
  id <NSFetchedResultsSectionInfo> sectionInfo
  = [self.fetchedResultsController sections][0];
  [self configureTitleWithString:@"COMPLETE"
                        subTitle:[NSString stringWithFormat:@"%ld items are completed.",
                                  (long)[sectionInfo numberOfObjects]]];
  
  // In the simplest, most efficient, case, reload the table view.
  [self.tableView endUpdates];
}

#pragma mark - その他

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
