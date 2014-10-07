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

static NSString *kCompleteCellID = @"CompleteCell";

#pragma mark -

@interface CompleteViewController ()

@end

@implementation CompleteViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"CompleteCell" bundle:nil]
       forCellReuseIdentifier:kCompleteCellID];
  
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
  LOG(@"セルが選択された");
}

-(void)updateTableView
{
  LOG(@"ナビゲーションバーを更新");
  [self configureTitleWithString:@"COMPLETE"
                        subTitle:[NSString stringWithFormat:@"%ld items are completed.",
                                  (long)[self.tableView numberOfRowsInSection:0]]];
  
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
  
    [self configureTitleWithString:@"COMPLETE"
                          subTitle:[NSString stringWithFormat:@"%ld items are completed.",
                                    (long)[self.tableView numberOfRowsInSection:0]]];
  
  // In the simplest, most efficient, case, reload the table view.
  [self.tableView endUpdates];
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
