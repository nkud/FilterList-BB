//
//  DetailViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "TitleCell.h"
#import "ItemDetailTagCell.h"
#import "ItemDetailDateCell.h"
#import "ItemDetailDatePickerCell.h"
#import "TagSelectViewController.h"
#import "Header.h"
#import "Tag.h"

#define kPickerAnimationDuration 0.4

#define kHeaderLabelFontSize 13

static NSString *kDateCellPlaceHold = @"due date";
static NSString *kTitleCellPlaceHold = @"tag";

// セルID
static NSString *kTagCellID = @"tagCell";
static NSString *kDateCellID = @"dateCell";
static NSString *kDatePickerCellID = @"datePickerCell";

#pragma mark -

@interface ItemDetailViewController () {
  BOOL didAcitivateKeyboard_;
}

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
  self = [super initWithNibName:nil
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
 * @brief  変数を初期化
 */
- (void)initParam
{
  didAcitivateKeyboard_ = NO;
}

/**
 * @brief  ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // 変数を初期化
  [self initParam];
  
  // セル登録
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
  
  // ピッカーセルの高さを取得
  self.heightForPickerCell
  = CGRectGetHeight([[self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID] frame]);
}

/**
 * @brief  ビュー表示後の処理
 *
 * @param animated アニメーション
 */
-(void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  if (didAcitivateKeyboard_ == NO) {
    TitleCell *cell = [self getTitleCell];
    [cell.titleField becomeFirstResponder];
    didAcitivateKeyboard_ = YES;
  }
}

/**
 * @brief  テキストのリターンが押された時の処理
 *
 * @param textField テキストフィールド
 *
 * @return 真偽値
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
  [self closeDatePickerCell];
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
 * @brief  タイトルセルを取得する
 *
 * @return タイトルセル
 */
-(TitleCell *)getTitleCell
{
  NSIndexPath *indexPathForTitleCell = [NSIndexPath indexPathForRow:0
                                                          inSection:0];
  TitleCell *cell
  = (TitleCell *)[self.tableView cellForRowAtIndexPath:indexPathForTitleCell];
  return cell;
}

/**
 * @brief  タグセルを取得する
 *
 * @return タグセル
 */
-(ItemDetailTagCell *)tagCell
{
  NSIndexPath *indexPathForDateCell = [NSIndexPath indexPathForRow:0
                                                         inSection:1];
  ItemDetailTagCell *cell
  = (ItemDetailTagCell *)[self.tableView cellForRowAtIndexPath:indexPathForDateCell];
  return cell;
}

/**
 * @brief  日付セルを取得する
 *
 * @return 日付セル
 */
-(ItemDetailDateCell *)dateCell
{
  NSIndexPath *indexPathForDateCell = [NSIndexPath indexPathForRow:1
                                                         inSection:1];
  ItemDetailDateCell *cell
  = (ItemDetailDateCell *)[self.tableView cellForRowAtIndexPath:indexPathForDateCell];
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
 * @brief  タイトルセルか評価する
 *
 * @param indexPath 位置
 *
 * @return 評価値
 */
-(BOOL)isTitleCellAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 0 && indexPath.row == 0) {
    return YES;
  }
  return NO;
}
/**
 * @brief  タグセルか評価する
 *
 * @param indexPath 位置
 *
 * @return 評価値
 */
-(BOOL)isTagCelAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 1 && indexPath.row == 0)
  {
    return YES;
  }
  return NO;
}
-(BOOL)isDateCellAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 1 && indexPath.row == 1) {
    return YES;
  } else {
    return NO;
  }
}
-(BOOL)isDatePickerCellAtIndexPath:(NSIndexPath *)indexPath
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
  TitleCell *cell = [self getTitleCell];
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

#pragma mark - テーブルビュー -

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
  if ([self isTitleCellAtIndexPath:indexPath])
  {
    TitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[self titleCellID]];
    [self configureTitleCell:cell atIndexPath:indexPath];
    return cell;
  }
  // タグセルを作成
  if ([self isTagCelAtIndexPath:indexPath]) {
    ItemDetailTagCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTagCellID];
    
    [self configureTagCell:cell
               atIndexPath:indexPath];
    return cell;
  }
  // 日時セルを作成
  if ([self isDateCellAtIndexPath:indexPath]) {
    ItemDetailDateCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDateCellID];
    [self configureDateCell:cell
                atIndexPath:indexPath];
    return cell;
  }
  // ピッカーセルを作成
  if ([self hasInlineDatePicker] && [self isDatePickerCellAtIndexPath:indexPath]) {
    ItemDetailDatePickerCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
    cell.delegate = self;
    return cell;
  }
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  return cell;
}

/**
 * @brief  ピッカーの高さを取得
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 *
 * @return 高さ
 */
-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isDatePickerCellAtIndexPath:indexPath]) {
    return self.heightForPickerCell;
  } else {
    return 44;
  }
}

/**
 * @brief  ヘッダービュー表示前処理
 *
 * @param tableView テーブルビュー
 * @param view      ヘッダー
 * @param section   セクション
 */
- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section {
  UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
  
  header.textLabel.textColor = [UIColor grayColor];
  header.textLabel.font = [UIFont systemFontOfSize:kHeaderLabelFontSize];
  CGRect headerFrame = header.frame;
  header.textLabel.frame = headerFrame;
}

#pragma mark デリゲート
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

  if ([cell.reuseIdentifier isEqualToString:[self titleCellID]])
  {
    // タグセルの処理
  } else if ([cell.reuseIdentifier isEqualToString:kTagCellID])
  {
    // タグ入力画面を表示
    [self closeDatePickerCell]; // 日付セルを閉じて
    [self presentTagSelectView]; // タグ選択画面を表示する
  } else if ([cell.reuseIdentifier isEqualToString:kDateCellID])
  {
    // リマインダーセルの処理
    TitleCell *tcell = [self getTitleCell];
    [tcell.titleField resignFirstResponder]; // キーボードは閉じる
    
    [self toggleDatePickerCell];
    [self configureDateCell:(ItemDetailDateCell *)cell
                atIndexPath:indexPath];
  }
  // 選択解除
  [tableView deselectRowAtIndexPath:indexPath
                           animated:YES];
}

#pragma mark データソース

/**
 * @brief  タグ入力画面を表示
 */
-(void)presentTagSelectView
{
  TagSelectViewController *controller
  = [[TagSelectViewController alloc] initWithNibName:@"TagSelectViewController"
                                              bundle:nil];
  controller.delegate = self;
//  controller.tagsForAlreadySelected = self.tagsForItem;
  controller.tagsForAlreadySelected = nil;
  controller.maxCapacityRowsForSelected = 1;
  
  UINavigationController *navcontroller = [[UINavigationController alloc] initWithRootViewController:controller];
  
  [self presentViewController:navcontroller
                     animated:YES
                   completion:^{
                   }];
}

/**
 * @brief  ピッカーセルを閉じる
 */
-(void)closeDatePickerCell
{
  if ([self hasInlineDatePicker]) {
    self.indexPathForDatePickerCell = nil;
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:2 inSection:1]];
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
  }
}
/**
 * @brief  ピッカーセルを開ける
 */
-(void)openDatePickerCell
{
  if ( ! [self hasInlineDatePicker]) {
    self.indexPathForDatePickerCell = [NSIndexPath indexPathForRow:2 inSection:1];
    NSArray *indexPaths = @[self.indexPathForDatePickerCell];
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
  }
}
/**
 * @brief  ピッカーセルを表示・非表示にする
 */
-(void)toggleDatePickerCell
{
  // ピッカーの表示・非表示
  [self.tableView beginUpdates];
  
  if ([self hasInlineDatePicker]) {
    [self closeDatePickerCell];
  } else {
    [self openDatePickerCell];
  }
  
  [self.tableView endUpdates];
}

#pragma mark - セルの設定

/**
 * @brief  タイトルセルを設定
 *
 * @param cell        セル
 * @param atIndexPath 位置
 */
-(void)configureTitleCell:(TitleCell *)cell
              atIndexPath:(NSIndexPath *)atIndexPath
{
  if (self.titleForItem)
  {
    cell.titleField.text = self.titleForItem;
  }
  cell.titleField.delegate = self;
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
  cell.textLabel.text = @"Tag";
  NSString *stringForTags;
  UIColor *textColor;
  if (self.tagsForItem && [self.tagsForItem count] > 0)
  {
    // タグが設定されている時
    stringForTags = [self createStringForSet:self.tagsForItem];
    textColor = [UIColor blackColor];
  } else
  {
    // タグが設定されていない時
    stringForTags = kTitleCellPlaceHold;
    textColor = [UIColor grayColor];
  }
  cell.detailTextLabel.text = stringForTags;
  
  if (self.tagsForItem != nil) {
    [self addCancelButton:cell
                   action:@selector(didTappedTagCancelButton:)];
  } else {
    cell.accessoryView = nil;
  }
}

/**
 * @brief  日時セルの設定
 *
 * @param cell        セル
 * @param atIndexPath 位置
 */
-(void)configureDateCell:(ItemDetailDateCell *)cell
             atIndexPath:(NSIndexPath *)atIndexPath
{
  cell.textLabel.text = @"Due Date";
  NSString *stringForDate;
  UIColor *colorForText;
  
  if (self.reminderForItem == nil && [self hasInlineDatePicker] == NO) {
    stringForDate = kDateCellPlaceHold;
    colorForText = [UIColor grayColor];
  } else {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    colorForText = [UIColor blackColor];
    if (self.reminderForItem) {
      stringForDate = [formatter stringFromDate:self.reminderForItem];
    } else {
      stringForDate = [formatter stringFromDate:[NSDate date]];
      self.reminderForItem = [NSDate date];
    }
  }
  cell.detailTextLabel.text = stringForDate;
  
  if (self.reminderForItem != nil) {
    [self addCancelButton:cell
                   action:@selector(didTappedDateCancelButton:)];
  } else {
    cell.accessoryView = nil;
  }
}

/**
 * @brief  キャンセルボタンが押された時
 *
 * @param sender センダー
 */
-(void)didTappedDateCancelButton:(id)sender
{
  if ([self hasInlineDatePicker]) {
    [self closeDatePickerCell];
  }
  self.reminderForItem = nil;
  
  // 日時セルを更新
  [self configureDateCell:[self dateCell]
              atIndexPath:nil];

}

/**
 * @brief  タグのキャンセルボタンが押された時
 *
 * @param sender センダー
 */
-(void)didTappedTagCancelButton:(id)sender
{
  self.tagsForItem = nil;
  
  // 日時セルを更新
  [self.tableView reloadData];
}

#pragma mark - デリゲート -
#pragma mark ピッカー
/**
 * @brief  ピッカーが変更された時の処理
 *
 * @param date 日時
 */
-(void)didChangedDate:(NSDate *)date
{
  // 日時を設定
  self.reminderForItem = date;
  // セルに反映させる
  [self.tableView reloadData];
}


#pragma mark タグ選択画面

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

  // 自身までポップ
//  [self.navigationController popToViewController:self
//                                        animated:YES];
//  [self.navigationController popToViewControllerFromBottom:self
//                                                  animated:YES];
  // 閉じる
//  [self dismissViewControllerAnimated:YES
//                           completion:^{
//                             ;
//                           }];
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
