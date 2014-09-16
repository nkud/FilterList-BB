//
//  DetailViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ItemDetailTitleCell.h"
#import "ItemDetailTagCell.h"
#import "ItemDetailDateCell.h"
#import "ItemDetailDatePickerCell.h"
#import "TagSelectViewController.h"
#import "Header.h"
#import "Tag.h"

#define kPickerAnimationDuration 0.4

// セルID
static NSString *kTitleCellID = @"titleCell";
static NSString *kTagCellID = @"tagCell";
static NSString *kDateCellID = @"dateCell";
static NSString *kDatePickerCellID = @"datePickerCell";

#pragma mark -

@interface ItemDetailViewController ()

-(NSString *)createStringForSet:(NSSet *)set;

@property (assign) NSInteger heightForPickerCell;

@end

@implementation ItemDetailViewController

#pragma mark - 初期化

/**
 * @brief  初期化
 *
 * @param title     タイトル
 * @param tags      関連するタグ
 * @param reminder  リマインダー
 * @param indexPath 位置
 * @param delegate  デリゲート
 *
 * @return インスタンス
 */
-(ItemDetailViewController *)initWithTitle:(NSString *)title
                                      tags:(NSSet *)tags
                                  reminder:(NSDate *)reminder
                                 indexPath:(NSIndexPath *)indexPath
                                  delegate:(id<ItemDetailViewControllerDelegate>)delegate
{
  self = [super initWithNibName:@"ItemDetailViewController"
                         bundle:nil];
  if (self)
  {
    if (title)
    {
      self.titleForItem= title;
      self.tagsForItem = tags;
      self.indexPathForItem = indexPath;
      self.reminderForItem = reminder;
      self.isNewItem = NO;
    } else
    {
      self.isNewItem = YES;
    }
    self.delegate = delegate;
  }
  return self;
}

/**
 * @brief  ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // セル登録
  [self.tableView registerNib:[UINib nibWithNibName:@"ItemDetailTitleCell"
                                             bundle:nil]
       forCellReuseIdentifier:kTitleCellID];
  [self.tableView registerNib:[UINib nibWithNibName:@"ItemDetailTagCell"
                                             bundle:nil]
       forCellReuseIdentifier:kTagCellID];
  [self.tableView registerNib:[UINib nibWithNibName:@"ItemDetailDateCell"
                                             bundle:nil]
       forCellReuseIdentifier:kDateCellID];
  [self.tableView registerNib:[UINib nibWithNibName:@"ItemDetailDatePickerCell"
                                             bundle:nil]
       forCellReuseIdentifier:kDatePickerCellID];

  // セーブボタン
  UIBarButtonItem *saveButton
  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                  target:self
                                                  action:@selector(saveAndDismiss)];
  self.navigationItem.rightBarButtonItem = saveButton;
  
  // スクロールを停止
  self.tableView.scrollEnabled = NO;
  
  self.heightForPickerCell = CGRectGetHeight([[self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID] frame]);
  LOG(@"%d", self.heightForPickerCell);
}

#pragma mark - 保存・終了処理

/**
 *  @brief 保存して戻る
 */
- (void)saveAndDismiss
{
  // アイテムを更新
  self.titleForItem = [self getTextOfTitleCell];
  
  // デリゲートに更新後アイテムを渡す
  [self.delegate dismissDetailView:self
                             title:self.titleForItem
                              tags:self.tagsForItem
                          reminder:self.reminderForItem
                         indexPath:self.indexPathForItem
                         isNewItem:self.isNewItem];
  // ビューを削除する
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ユーティリティ

/**
 * @brief  タイトルセルを取得
 *
 * @return タイトルセル
 */
-(ItemDetailTitleCell *)getTitleCell
{
  NSIndexPath *indexPathForTitleCell = [NSIndexPath indexPathForRow:0
                                                          inSection:0];
  ItemDetailTitleCell *cell
  = (ItemDetailTitleCell *)[self.tableView cellForRowAtIndexPath:indexPathForTitleCell];
  return cell;
}

/**
 * @brief  タグのセットから文字列を作成
 *
 * @param set タグのセット
 *
 * @return 文字列
 */
-(NSString *)createStringForSet:(NSSet *)set
{
  NSMutableString *string = [[NSMutableString alloc] init];
  for( Tag *tag in set )
  { //< すべてのタグに対して
    [string appendString:tag.title]; //< フィールドに足していく
    [string appendString:@" "];
  }
  LOG(@"%@", string);
  return string;
}

/**
 * @brief  タイトルセルか評価
 *
 * @param indexPath 位置
 *
 * @return 評価値
 */
-(BOOL)isTitleCell:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0 && indexPath.row == 0) {
    return YES;
  }
  return NO;
}
/**
 * @brief  タグセルか評価
 *
 * @param indexPath 位置
 *
 * @return 評価値
 */
-(BOOL)isTagCell:(NSIndexPath *)indexPath
{
  if (indexPath.section == 1 && indexPath.row == 0)
  {
    return YES;
  }
  return NO;
}
-(BOOL)isDateCell:(NSIndexPath *)indexPath
{
  if (indexPath.section == 1 && indexPath.row == 1) {
    return YES;
  } else {
    return NO;
  }
}
-(BOOL)isDatePickerCell:(NSIndexPath *)indexPath
{
  if (indexPath.section == 1 && indexPath.row == 2) {
    return YES;
  } else {
    return NO;
  }
}
/**
 * @brief  現在入力されているタイトルを取得
 *
 * @return 文字列
 */
-(NSString *)getTextOfTitleCell
{
  ItemDetailTitleCell *cell = [self getTitleCell];
  return cell.titleField.text;
}

/**
 * @brief  ピッカーが表示されているか
 *
 * @return 真偽値
 */
-(BOOL)hasInlineDatePicker
{
  if (self.indexPathForDatePickerCell) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - テーブルビュー

/**
 * @brief  セクション数を返す
 *
 * @param tableView テーブルビュー
 *
 * @return セクション数
 */
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 2;
}

/**
 * @brief  セクションのタイトル
 *
 * @param tableView テーブルビュー
 * @param section   セクション
 *
 * @return タイトル
 */
-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
  if (section == 0)
  {
    return @"TITLE";
  } else
  {
    return @"OPTION";
  }
}

/**
 * @brief  セクション内のセル数
 *
 * @param tableView テーブルビュー
 * @param section   セクション
 *
 * @return セル数
 */
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  if (section == 0)
  {
    return 1;
  } else
  {
    if ([self hasInlineDatePicker])
    {
      return 2+1;
    }
    return 2;
  }
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
  // タイトルセルを作成
  if ([self isTitleCell:indexPath])
  {
    ItemDetailTitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTitleCellID];
    [self configureTitleCell:cell atIndexPath:indexPath];
    return cell;
  }
  // タグセルを作成
  if ([self isTagCell:indexPath]) {
    ItemDetailTagCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTagCellID];
    
    [self configureTagCell:cell
               atIndexPath:indexPath];
    return cell;
  }
  if ([self isDateCell:indexPath]) {
    ItemDetailDateCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDateCellID];
    cell.textLabel.text = @"date";
    return cell;
  }
  if ([self hasInlineDatePicker] && [self isDatePickerCell:indexPath]) {
    ItemDetailDatePickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
    return cell;
  }
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  return cell;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isDatePickerCell:indexPath]) {
    return self.heightForPickerCell;
  } else {
    return 44;
  }
}

/**
 * @brief  タイトルセルを設定
 *
 * @param cell        セル
 * @param atIndexPath 位置
 */
-(void)configureTitleCell:(ItemDetailTitleCell *)cell
              atIndexPath:(NSIndexPath *)atIndexPath
{
  if (self.titleForItem)
  {
    cell.titleField.text = self.titleForItem;
  }
}

/**
 * @brief  タグセルを設定
 *
 * @param cell        セル
 * @param atIndexPath 位置
 */
-(void)configureTagCell:(ItemDetailTagCell *)cell
            atIndexPath:(NSIndexPath *)atIndexPath
{
  NSString *string;
  string = [self createStringForSet:self.tagsForItem];
  cell.textLabel.text = string;
}

/**
 * @brief  タグが選択された時の処理
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 */
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
  LOG(@"%@", cell.reuseIdentifier);
  // タグセルの処理
  if ([cell.reuseIdentifier isEqualToString:kTagCellID])
  {
    // タグ選択画面を作成
    TagSelectViewController *tagSelectViewController
    = [[TagSelectViewController alloc] initWithNibName:nil
                                                bundle:nil];
    tagSelectViewController.delegate = self;
    tagSelectViewController.tagsForAlreadySaved = self.tagsForItem;
    // タグ選択画面をプッシュ
    [self.navigationController pushViewController:tagSelectViewController
                                         animated:YES];
  } else if ([cell.reuseIdentifier isEqualToString:kDateCellID])
  { // リマインダーセルの処理
    // キーボードは閉じる
    ItemDetailTitleCell *tcell = [self getTitleCell];
    [tcell.titleField resignFirstResponder];
    // ピッカーの表示・非表示
    NSArray *indexPaths;
    [self.tableView beginUpdates];
    if ([self hasInlineDatePicker]) {
      self.indexPathForDatePickerCell = nil;
      indexPaths = @[[NSIndexPath indexPathForRow:2 inSection:1]];
      [self.tableView deleteRowsAtIndexPaths:indexPaths
                            withRowAnimation:UITableViewRowAnimationFade];
    } else {
      self.indexPathForDatePickerCell = [NSIndexPath indexPathForRow:2 inSection:1];
      indexPaths = @[self.indexPathForDatePickerCell];
      [self.tableView insertRowsAtIndexPaths:indexPaths
                            withRowAnimation:UITableViewRowAnimationFade];
    }
    [self.tableView endUpdates];
  }
}

#pragma mark - タグ選択画面デリゲート

/**
 * @brief  タグ選択画面を終了する
 *
 * @param tagsForSelectedRows 選択されたタグ
 */
-(void)dismissTagSelectView:(NSSet *)tagsForSelectedRows
{
  // 選択されたタグを取得する
  self.tagsForItem = tagsForSelectedRows;
  /// @todo 効率悪い
  [self.tableView reloadData];
}

#pragma mark - その他
/**
 * @brief  メモリー警告
 */
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
