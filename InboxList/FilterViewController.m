//
//  FilterViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/12.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "FilterViewController.h"
#import "CoreDataController.h"

#import "FilterDetailViewController.h"

#import "Header.h"
#import "FilterCell.h"
#import "Filter.h"

#import "Configure.h"

static NSString *kFilterCellID = @"FilterCell";

#pragma mark -

@interface FilterViewController ()

@end

@implementation FilterViewController

#pragma mark - 初期化 -

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

-(void)initParameter
{
  self.navbarThemeColor = FILTER_COLOR;
}

/**
 *  @brief ビューを読み込んだ後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];

  [self initParameter];
  
  // 編集中の複数選択を不可にする
  self.tableView.allowsMultipleSelectionDuringEditing = NO;

  // タイトルを設定
  [self configureTitleWithString:FILTER_LIST_TITLE
                        subTitle:nil
                        subColor:FILTER_COLOR];
  self.titleLabel.textColor = FILTER_COLOR;
  
//  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"FilterCell"];
//  [self.tableView registerNib:[UINib nibWithNibName:@"FilterCell"
//                                             bundle:nil]
//       forCellReuseIdentifier:kFilterCellID];
  
  // セルを登録
//  [self.tableView registerNib:[UINib nibWithNibName:@"FilterCell"
//                                             bundle:nil]
//       forCellReuseIdentifier:@"FilterCell"];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:@"FilterCell"];
  // 編集ボタンを追加
  self.navigationItem.rightBarButtonItem = [self newInsertObjectButton];
  self.navigationItem.rightBarButtonItem.tintColor = FILTER_COLOR;
  self.navigationItem.leftBarButtonItem = [self newEditTableButton];
  self.navigationItem.leftBarButtonItem.tintColor = FILTER_COLOR;

  // テーブルを設定する
  self.tableView.backgroundColor = FILTER_BG_COLOR;
  CGRect frame = self.tableView.frame;
  frame.size.width -= ITEM_LIST_REMAIN_MARGIN;
  self.tableView.frame = frame;

}

/**
 * @brief  ビュー表示前の処理
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

-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // タグモードの時のみ
  if ([self.delegateForList isTopViewController:self] && self.tableView.isEditing == NO) {
    [self.delegateForList listDidEditMode];
  }
}

-(void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
}

#pragma mark - フィルター入力 -

-(void)didTappedEditTableButton
{
//  [super didTappedEditTableButton];

  if (self.tableView.isEditing) {
    [self.delegateForList listDidEditMode];
  } else {
    [self.delegateForList listWillEditMode];
  }

  [self toEdit:self];
  
  [self hideEditTabBar:YES];
}

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

-(void)didTappedInsertObjectButton
{
  [super didTappedInsertObjectButton];
  
  [self presentInputFilterView];
}


/**
 *  @brief フィルター入力画面を表示する
 */
-(void)presentInputFilterView
{
  [self.delegateForList listWillEditMode];
  [self.delegateForList closeTabBar];
  
  LOG(@"フィルター入力画面を作成・表示");
  // 初期化
  FilterDetailViewController *controller
  = [[FilterDetailViewController alloc] initWithFilterTitle:nil
                                                       tags:nil
                                                       from:nil
                                                   interval:nil
                                              filterOverdue:NO
                                                filterToday:NO
                                               filterFuture:NO
                                                isNewFilter:YES
                                                  indexPath:nil
                                                   delegate:self];
  
  // プッシュ
  [self.navigationController pushViewController:controller
                                       animated:YES];
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
  if ([filterTitle isEqualToString:@""]) {
    ;
  } else {
    [CoreDataController insertNewFilter:filterTitle
                          tagsForFilter:tagsForSelected];
  }
}

#pragma mark - テーブルビュー -
#pragma mark デリゲート

-(BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  return YES;
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
  if (tableView.isEditing) {
    return;
  }
  Filter *filter = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [self.delegate didSelectedFilter:filter.title
                              tags:filter.tags
                            filter:filter];
  
  // セルの選択を解除する
  [self.tableView deselectRowAtIndexPath:indexPath
                                animated:YES];
}

#pragma mark データソース

/**
 * @brief  セルの削除を行えるようにする
 *
 * @param tableView    テーブルビュー
 * @param editingStyle スタイル
 * @param indexPath    位置
 */
-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  switch (editingStyle) {
    case UITableViewCellEditingStyleDelete:
    {
      // フィルターを削除する
      Filter *deleteFilter = [self.fetchedResultsController objectAtIndexPath:indexPath];
      [[CoreDataController managedObjectContext] deleteObject:deleteFilter];
      NSInteger deleteFilterOrder = deleteFilter.order.integerValue;
      
      // 順序を整理する
      NSArray *filters = [self.fetchedResultsController fetchedObjects];
      NSInteger newOrder;
      for (Filter *filter in filters) {
        NSInteger order = filter.order.integerValue;
        if (order > deleteFilterOrder) {
          newOrder = order - 1;
          filter.order = [NSNumber numberWithInteger:newOrder];
        }
      }
      [CoreDataController saveContext];
      break;
    }
    default:
      break;
  }
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

/**
 * @brief  セルを作成
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 *
 * @return セル
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//  FilterCell *cell = [tableView dequeueReusableCellWithIdentifier:kFilterCellID];
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                  reuseIdentifier:@"cell"];
  }
  
  [self configureFilterCell:cell
                atIndexPath:indexPath];
  return cell;
}

#pragma mark セル設定

/**
 *  @brief セルを設定する
 *
 *  @param cell      設定するセル
 *  @param indexPath セルのパス
 *
 *  @return 設定されたセル
 */
-(void)configureFilterCell:(UITableViewCell *)cell
               atIndexPath:(NSIndexPath *)indexPath
{
  // フィルターを取得して、
  // フィルターの情報を表示する。
  Filter *filter = [self.fetchedResultsController objectAtIndexPath:indexPath];
//  cell.titleLabel.text = filter.title;
  cell.textLabel.text = filter.title;
//  cell.tagLabel.text = [self createStringForSet:filter.tags];
  cell.detailTextLabel.text = [self createStringForSet:filter.tags];
  
  // アクセサリー
//  cell.accessoryView = [self newDisclosureIndicatorAccessory];
  cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;

  // 背景色を設定する
  cell.backgroundColor = FILTER_BG_COLOR;
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
  
  Filter *filter = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  FilterDetailViewController *controller
  = [[FilterDetailViewController alloc] initWithFilterTitle:filter.title
                                                       tags:filter.tags
                                                       from:filter.from
                                                   interval:filter.interval
                                              filterOverdue:filter.overdue.boolValue
                                                filterToday:filter.today.boolValue
                                               filterFuture:filter.future.boolValue
                                                isNewFilter:NO
                                                  indexPath:indexPath
                                                   delegate:self];
  
  // プッシュ
  [self.navigationController pushViewController:controller
                                       animated:YES];
  [self.delegateForList closeTabBar];
}


#pragma mark - ユーティリティ -

-(NSString *)createStringForSet:(NSSet *)set
{
  NSMutableString *string = [[NSMutableString alloc] init];
  
  for( Tag *tag in set )
  {
    // 全てのタグに対して、
    // フィールドに足していく。
    [string appendString:tag.title];
    [string appendString:@" "];
  }
  
  return string;
}


#pragma mark - セルの移動
-(void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
     toIndexPath:(NSIndexPath *)destinationIndexPath
{
  NSInteger minRowIdx, maxRowIdx;
  BOOL isMoveDirectionSmallToLarge;
  if(sourceIndexPath.row == destinationIndexPath.row){
    return;
  }else if(sourceIndexPath.row < destinationIndexPath.row){
    minRowIdx = sourceIndexPath.row;
    maxRowIdx = destinationIndexPath.row;
    isMoveDirectionSmallToLarge = YES;
  }else{
    minRowIdx = destinationIndexPath.row;
    maxRowIdx = sourceIndexPath.row;
    isMoveDirectionSmallToLarge = NO;
  }
  for(NSInteger i = minRowIdx; i <= maxRowIdx; i++){
    NSIndexPath *itIndexPath = INDEX(i, 0);
    Tag *tag = [self.fetchedResultsController objectAtIndexPath:itIndexPath];
    NSNumber *displayOrder = tag.order;
    NSInteger newOrder;
    
    // 移動前位置なら、移動先に移動。
    // その他の位置なら、１つずらす。
    if(i == sourceIndexPath.row){
      newOrder = destinationIndexPath.row;
    }else if(isMoveDirectionSmallToLarge){
      newOrder = displayOrder.integerValue - 1;
    }else{
      newOrder = displayOrder.integerValue + 1;
    }
    LOG(@"%ld, %ld, %ld", (long)i, (long)displayOrder.integerValue, (long)newOrder);
    tag.order = [NSNumber numberWithInteger:newOrder];
  }
}


#pragma mark - コンテンツの更新 -

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
      [self configureFilterCell:(FilterCell *)[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];                                // これであってる？？

      break;

    case NSFetchedResultsChangeMove:
      LOG(@"移動");
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
  // In the simplest, most efficient, case, reload the table view.
  [CoreDataController saveContext];
  [self.tableView endUpdates];
}

#pragma mark - その他 -
#pragma mark 詳細ビューデリゲート
-(void)dismissInputFilterView:(NSString *)filterTitle
              tagsForSelected:(NSSet *)tagsForSelected
                         from:(NSDate *)from
                     interval:(NSDate *)interval
                filterOverdue:(BOOL)overdue
                  filterToday:(BOOL)today
                 filterFuture:(BOOL)future
                    indexPath:(NSIndexPath *)indexPath
                  isNewFilter:(BOOL)isNewFilter
{
  if ([filterTitle isEqualToString:@""]) {
    return;
  }
  NSIndexPath *indexPathInController = indexPath;
  Filter *filter;
  if (isNewFilter) {
    filter = [CoreDataController newFilterObject];
  } else {
    filter = [self.fetchedResultsController objectAtIndexPath:indexPathInController];
  }
  filter.title = filterTitle;
  filter.tags = tagsForSelected;
  filter.from = from;
  filter.interval = interval;
  filter.overdue = [NSNumber numberWithBool:overdue];
  filter.today = [NSNumber numberWithBool:today];
  filter.future = [NSNumber numberWithBool:future];
  LOG(@"%@", filter);
  [CoreDataController saveContext];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 */


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
