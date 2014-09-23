//
//  FilterViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/12.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "FilterViewController.h"
#import "CoreDataController.h"
#import "InputFilterViewController.h"
#import "Header.h"
#import "FilterCell.h"
#import "Filter.h"

#import "Configure.h"

@interface FilterViewController ()

- (void)configureFilterCell:(FilterCell *)cell
                atIndexPath:(NSIndexPath *)indexPath;

@end

@implementation FilterViewController

#pragma mark - 初期化
/**
 *  @brief 初期化
 *
 *  @param nibNameOrNil   nibNameOrNil description
 *  @param nibBundleOrNil nibBundleOrNil description
 *
 *  @return return value description
 */
- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];
  return self;
}


/**
 *  @brief ビューを読み込んだ後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];

  // タイトルを設定
  [self configureTitleWithString:FILTER_LIST_TITLE
                       miniTitle:@"mini title"];
  
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FilterCell"];
  
  // セルを登録
  [self.tableView registerNib:[UINib nibWithNibName:@"FilterCell"
                                             bundle:nil]
       forCellReuseIdentifier:@"FilterCell"];
  LOG(@"編集ボタンを追加");
  UIBarButtonItem *newFilterButton
  = [[UIBarButtonItem alloc] initWithTitle:@"新規"
                                     style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(presentInputFilterView)];
  self.navigationItem.rightBarButtonItem = newFilterButton;
}


#pragma mark - フィルター入力

/**
 *  @brief フィルター入力画面を表示する
 */
-(void)presentInputFilterView
{
  LOG(@"フィルター入力画面を作成・表示");
  // 初期化
  InputFilterViewController *inputFilterView = [[InputFilterViewController alloc]
                                                initWithNibName:nil
                                                bundle:nil];
  inputFilterView.delegate = self;
  // 入力画面を最前面に表示する
  [self.view bringSubviewToFront:inputFilterView.view];
  // 入力画面を表示する
  [self presentViewController:inputFilterView
                     animated:YES
                   completion:nil];
}

/**
 * @brief  フィルター入力画面を終了する
 *
 * @param filterTitle     入力されたフィルター
 * @param tagsForSelected 選択されたタグ
 *
 * @todo リマインダーも入力の必要あり
 */
-(void)dismissInputFilterView:(NSString *)filterTitle
              tagsForSelected:(NSSet *)tagsForSelected
{
  LOG(@"フィルターを追加");
  
  // フィルターを新規挿入
  [CoreDataController insertNewFilter:filterTitle
                        tagsForFilter:tagsForSelected];
  
  LOG(@"フィルター入力画面を終了");
  [self dismissViewControllerAnimated:YES
                           completion:nil];
}

#pragma mark - テーブルビュー

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
  Filter *filter = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [self.delegate didSelectedFilter:filter.title
                              tags:filter.tags];
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

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"FilterCell";
  FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  [self configureFilterCell:cell
                atIndexPath:indexPath];
  return cell;
}

/**
 *  @brief セルを設定する
 *
 *  @param cell      設定するセル
 *  @param indexPath セルのパス
 *
 *  @return 設定されたセル
 */
-(void)configureFilterCell:(FilterCell *)cell
               atIndexPath:(NSIndexPath *)indexPath
{
  LOG(@"セルを設定");
  Filter *filter = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = filter.title;
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
      [self configureFilterCell:(FilterCell *)[tableView cellForRowAtIndexPath:indexPath]
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

#pragma mark - メモリー警告

/**
 *  @brief メモリー警告
 */
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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

@end
