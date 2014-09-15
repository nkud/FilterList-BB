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
#import "TagSelectViewController.h"
#import "Header.h"
#import "Tag.h"

#define kPickerAnimationDuration 0.4

static NSString *kTitleCellID = @"titleCell";
static NSString *kTagCellID = @"tagCell";

#pragma mark -

@interface ItemDetailViewController ()

-(NSString *)createStringForSet:(NSSet *)set;

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
  
  // セーブボタン
  UIBarButtonItem *saveButton
  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                  target:self
                                                  action:@selector(saveAndDismiss)];
  self.navigationItem.rightBarButtonItem = saveButton;
  
  // スクロールを停止
  self.tableView.scrollEnabled = NO;
}

#pragma mark - 保存・終了処理

-(void)updateItem
{
  self.titleForItem = [self getTextOfTitleCell];
}

/**
 *  @brief 保存して戻る
 */
- (void)saveAndDismiss
{
  // アイテムを更新
  [self updateItem];
  
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
  if (section == 0) {
    return 1;
  } else
  {
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
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  return cell;
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
