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
#import "InputModalViewController.h"
#import "Tag.h"
#import "Item.h"
#import "ItemCell.h"
#import "Header.h"
#import "InputHeader.h"

@interface ItemViewController () {
  int location_center_x;
  BOOL isOpen;
  AppDelegate *app;
}

- (void)configureCell:(ItemCell *)cell
          atIndexPath:(NSIndexPath *)indexPath;
@end

@implementation ItemViewController

/**
*  現存するタグリストを返す
*
*  @return タグのリスト
*/
-(NSArray *)getTagList
{
  NSLog(@"%s", __FUNCTION__);
  NSMutableArray *taglist = [[NSMutableArray alloc] init];           //< 返す配列
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag"
                                            inManagedObjectContext:app.managedObjectContext];
  request.entity = entity;
  request.sortDescriptors = nil;                                     //< @TODO メニューをソートする場合はここ
  NSArray *objs = [app.managedObjectContext executeFetchRequest:request
                                                           error:nil];
  for ( Tag *tag in objs ) {
    /// @todo タグ関連は要変更
    if ([tag.title isEqual:@""]) continue;                           //< タイトルが未設定ならスキップ
    if ([tag.items count]==0) continue;                              //< アイテムに紐付けされていなければスキップ

    [taglist addObject:tag.title];
  }
  return taglist;
}

/**
 *  チェックボックスがタップされた時の処理
 *
 *  @param cell  タップされたセル
 *  @param touch タッチ？
 */
-(void)tappedCheckBox:(ItemCell *)cell
                touch:(UITouch *)touch
{
  // 位置を取得して
  CGPoint tappedPoint = [touch locationInView:self.view];
  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:tappedPoint];

  // その位置のセルのデータをモデルから取得する
  Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];

  BOOL checkbox = [[item valueForKey:@"state"] boolValue];
  if (checkbox == FALSE) { // 完了にする
    [app.managedObjectContext deleteObject:item];
  }

//  // チェックの状態を変更して
//  BOOL checkbox = ! [[item valueForKey:@"state"] boolValue];
//  item.state = [NSNumber numberWithBool:checkbox];
//
//  // チェックボックスを更新する
//  [cell updateCheckBox:checkbox];

  // モデルを保存する
  [app saveContext];
}

/**
 *  パラメータを初期化
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
 *  初期化
 *
 *  @param style <#style description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithStyle:(UITableViewStyle)style
{
  self = [super initWithStyle:style];

  if (self) {
    self.title = @"master";
  }

  return self;
}

/**
 *  ビューがロードされたあとの処理
 */
- (void)viewDidLoad
{
  NSLog(@"%s", __FUNCTION__);
  [super viewDidLoad];

  // 変数を初期化
  [self initParameter];

  // セルとして使うクラスを登録する
//  [self.tableView registerClass:[ItemCell class]
//         forCellReuseIdentifier:@"ItemCell"];
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

  // 入力ヘッダ
  self.inputHeader = [[InputHeader alloc] initWithFrame:self.tableView.bounds];
  self.inputHeader.delegate = self;
  [self.tableView addSubview:self.inputHeader];
}

/**
 *  スクロール時の処理
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGRect rect = scrollView.bounds; // 現在のスクロールビューの位置を取得して
  self.triggerDragging = rect.origin.y; // ドラッグしている距離を更新
}

/**
 *  @brief スクロールをドラッグした後の処理
 *
 *  @param scrollView <#scrollView description#>
 *  @param decelerate <#decelerate description#>
 *
 *  @todo  入力ヘッダを綺麗に出すようにする
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                 willDecelerate:(BOOL)decelerate
{
  if (self.triggerDragging < -120) { // 規定値よりもドラッグすると
    NSLog(@"%@", @"クイック入力");
    [self.inputHeader activateInput]; // クイック入力を作動させる
  }
}

/**
 *  @brief タイトルだけ指定して新しいアイテムを追加
 *
 *  @param itemString 追加するアイテムのタイトル
 */
-(void)quickInsertNewItem:(NSString *)itemString
{
  NSLog(@"%s", __FUNCTION__);
  [self insertNewObject:self
                  title:itemString
                    tag:[NSSet setWithObject:self.selectedTagString]
               reminder:[NSDate date]];
}

/**
 *  編集
 *
 *  @param sender <#sender description#>
 */
- (void)toEdit:(id)sender
{
  NSLog(@"%s", __FUNCTION__);
  if (self.tableView.isEditing) {
    [self setEditing:false animated:YES];
  } else {
    [self setEditing:true animated:YES];
  }
}

/**
 *  @brief 入力画面を終了させる処理
 *
 *  @param sender   sender description
 *  @param data     受け取った入力
 *  @param reminder 設定されたリマインダー
 */
- (void)dismissInputModalView:(id)sender
                         data:(NSArray *)data
                     reminder:(NSDate *)reminder
{
  NSLog(@"%s", __FUNCTION__);
  NSString *title = data[0];                                         //< タイトルを取得して
  if (title.length > 0) {                                            //< 空欄でなければ
    [self insertNewObject:sender
                    title:data[0]
                      tag:[NSSet setWithObject:data[1]]
                 reminder:reminder];
  }
  [self dismissViewControllerAnimated:YES completion:nil];           //< ビューを削除
}

/**
 *  @brief 詳細画面を終了させる処理
 *
 *  @param sender    sender description
 *  @param indexPath 詳細を表示したセルの位置
 *  @param itemTitle 更新されたアイテムのタイトル
 *  @param tagTitles 更新されたタグ
 */
-(void)dismissDetailView:(id)sender
                   index:(NSIndexPath *)indexPath
               itemTitle:(NSString *)itemTitle
               tagTitles:(NSArray *)tagTitles
{
  NSLog(@"%s", __FUNCTION__);
  // アイテムを取得
  Item *item = [self.fetchedResultsController objectAtIndexPath:indexPath];

  [item setValue:itemTitle forKeyPath:@"title"]; //< 更新後のタイトルを代入
  // 更新後のタグを代入
  // ここでは空白区切りで羅列している
  NSMutableSet *tags = [[NSMutableSet alloc] init];
  for( NSString *title in tagTitles ) {
    Tag *newTag = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                                inManagedObjectContext:[app managedObjectContext]];
    newTag.title = title;
    [newTag addItems:[NSSet setWithObject:item]];
    [tags addObject:newTag];
  }
  [item setValue:tags forKeyPath:@"tags"];

  // モデルを保存する
  [app saveContext];
}

/**
 *  入力画面を表示する
 */
-(void)presentInputItemView
{
  InputModalViewController *inputView = [[InputModalViewController alloc] initWithNibName:@"InputItemViewController"
                                                                                   bundle:nil];
  inputView.delegate = self;
  [inputView setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
  [self presentViewController:inputView
                     animated:YES
                   completion:nil];
}

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
  NSLog(@"%s", __FUNCTION__);
  // ここはよくわからない
  // 特になくても、直接指定すればいいのでは？
  NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
  NSEntityDescription *entity     = [[self.fetchedResultsController fetchRequest] entity];


  // If appropriate, configure the new managed object.
  // Normally you should use accessor methods, but using KVC here avoids the need to add a custom class to the template.
  //    [newManagedObject setValuesForKeysWithDictionary:nsdictionary];

  /**
   *  アイテムを初期化
   */
  Item *newItem    = [NSEntityDescription insertNewObjectForEntityForName:[entity name]
                                                   inManagedObjectContext:context];
  newItem.title    = title;// タイトル
  newItem.state    = [NSNumber numberWithBool:false];// 未完了状態
  newItem.reminder = reminder;// 日付

  /**
   *  タグを初期化
   */
  for (NSString *tagTitle in tagTitleSet) // 指定されたタグの数だけ
  {
    NSLog(@"%@%@", @"new tag: ", tagTitle);
    Tag *newTag  = [NSEntityDescription insertNewObjectForEntityForName:@"Tag"
                                                 inManagedObjectContext:context];
    /**
     *  タグとアイテムを紐付
     */
    newTag.title = tagTitle; // タイトル
    [newTag addItemsObject:newItem];
    [newItem addTagsObject:newTag];
  }
  
  /**
   *  保存する
   */
  [app saveContext];
}

#pragma mark - Table View

/**
 *  テーブルビューを更新する
 *
 * @todo 効率のいい更新方法にする
 */
- (void)updateTableView
{
  NSLog(@"%s", __FUNCTION__);
  [self.tableView reloadData];
}

/**
 *  セルを作成する
 *
 *  @param cell      作成するセル
 *  @param indexPath 作成するセルの位置
 */
- (void)configureCell:(ItemCell *)cell
          atIndexPath:(NSIndexPath *)indexPath
{
  Item *item                 = [self.fetchedResultsController objectAtIndexPath:indexPath];
//  cell.textLabel.text = [[object valueForKey:@"title"] description]; // text
  cell.textLabel.text        = item.title;
  [cell updateCheckBox:item.state.boolValue];

  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  formatter.dateFormat       = @"yyyy/MM/dd";
  cell.detailTextLabel.text  = [formatter stringFromDate:item.reminder];
  cell.delegate              = self;// delegate
}

/**
 *  セルが選択された時の処理
 *
 *  @param tableView テーブルビュー
 *  @param indexPath 選択された場所
 */
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//  ItemDetailViewController *detailViewController = [[ItemDetailViewController alloc] init];
  ItemDetailViewController *detailViewController = [[ItemDetailViewController alloc] initWithNibName:@"ItemDetailViewController"
                                                                                              bundle:nil];
  Item *object = [self.fetchedResultsController objectAtIndexPath:indexPath];

  [detailViewController setDetailItem:object];
  [detailViewController setIndex:indexPath];
  [detailViewController setDelegate:self];

  [self.navigationController pushViewController:detailViewController
                                       animated:NO];
}

/**
 *  セクション数を返す
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
 *  指定されたセクションのアイテム数
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
 *  指定された位置のセル
 *
 *  @param tableView テーブルビュー
 *  @param indexPath 指定する位置
 *
 *  @return セル
 */
- (ItemCell *)tableView:(UITableView *)tableView
cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"%s", __FUNCTION__);
  static NSString *CellIdentifier = @"ItemCell";
  ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  [self configureCell:cell atIndexPath:indexPath];
  return cell;
}

/**
 *  テーブル編集の可否
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
 *  編集時の処理
 *
 *  @param tableView    テーブルビュー
 *  @param editingStyle 編集スタイル
 *  @param indexPath    選択された位置
 */
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
  /// 削除時
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    NSManagedObjectContext *context = [[self fetchedResultsController] managedObjectContext];
    [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    [app saveContext];
  }
}

/**
 * ？？？
 */
- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
  // The table view should not be re-orderable.
  return YES;
}

/**
 *  ???
 *
 *  @param tableView            テーブルビュー
 *  @param sourceIndexPath      元の位置？
 *  @param destinationIndexPath 後の位置？
 */
-(void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
     toIndexPath:(NSIndexPath *)destinationIndexPath
{
  NSLog(@"%s", "Moved");
}

#pragma mark - Fetched results controller

/**
 *  コンテンツを更新する前処理
 *
 *  @param controller リザルトコントローラー
 */
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
  [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
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
  NSLog(@"controller: %@", controller);
  UITableView *tableView = self.tableView;

  switch(type) {
    case NSFetchedResultsChangeInsert:
      NSLog(@"%@", @"insert");
      [tableView insertRowsAtIndexPaths:@[newIndexPath]
                       withRowAnimation:UITableViewRowAnimationLeft];
      break;

    case NSFetchedResultsChangeDelete:
      NSLog(@"%@", @"delete");
      [tableView deleteRowsAtIndexPaths:@[indexPath]
                       withRowAnimation:UITableViewRowAnimationLeft];
      break;

    case NSFetchedResultsChangeUpdate:
      NSLog(@"%@", @"update");
      [self configureCell:(ItemCell *)[tableView cellForRowAtIndexPath:indexPath]
              atIndexPath:indexPath];                                // これであってる？？
      break;

    case NSFetchedResultsChangeMove:
      NSLog(@"%@", @"move");
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
  NSLog(@"%s", __FUNCTION__);
  // In the simplest, most efficient, case, reload the table view.
  [self.tableView endUpdates];
}

/**
 *  メモリー警告
 */
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
