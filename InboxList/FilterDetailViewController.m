//
//  InputFilterViewController2.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/12.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "FilterDetailViewController.h"
#import "FilterCell.h"
#import "CoreDataController.h"

#import "TitleCell.h"
#import "ItemDetailDatePickerCell.h"

#import "ItemDetailTagCell.h"
#import "SwitchCell.h"

#import "TagSelectViewController.h"

#import "Header.h"

#define kDatePickerTag 99

#pragma mark Cell Identifier
static NSString *kTagSelectCellID = @"tagCell";
static NSString *kDueDateCellID = @"DueDateCell";
static NSString *kDatePickerCellID = @"DatePickerCell";
static NSString *kSearchCellID = @"SearchCell";
static NSString *kSwitchCellID = @"SwitchCell";

static NSString *kTagCellNibName = @"ItemDetailTagCell";
static NSString *kDatePickerCellNibName = @"ItemDetailDatePickerCell";

#pragma mark -

@interface FilterDetailViewController ()
{
  NSArray *dataArray_;
  
  BOOL didActivatedKeyboard_;
  
  NSArray *indexPathsForSelectionPanel_;
  BOOL stateOfSwitchOne_;
  BOOL stateOfSwitchTwo_;
  BOOL stateOfSwitchThree_;
}

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation FilterDetailViewController

#pragma mark - 初期化

/**
 * @brief  セルを登録
 */
-(void)registerClassForCells
{
  [self.tableView registerNib:[UINib nibWithNibName:kTagCellNibName
                                             bundle:nil]
       forCellReuseIdentifier:kTagSelectCellID];
  
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kDueDateCellID];
  
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kSearchCellID];
  
  [self.tableView registerNib:[UINib nibWithNibName:kDatePickerCellNibName
                                             bundle:nil]
       forCellReuseIdentifier:kDatePickerCellID];
  
  [self.tableView registerClass:[SwitchCell class]
         forCellReuseIdentifier:kSwitchCellID];
}

/**
 * @brief  初期化
 *
 * @param title       タイトル
 * @param tags        タグ
 * @param isNewFilter 新規・更新
 *
 * @return インスタンス
 */
-(instancetype)initWithFilterTitle:(NSString *)title
                              tags:(NSSet *)tags
                              from:(NSDate *)from
                          interval:(NSDate *)interval
                       isNewFilter:(BOOL)isNewFilter
                         indexPath:(NSIndexPath *)indexPath
                          delegate:(id<FilterDetailViewControllerDelegate>)delegate
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    if (title) {
      self.titleForFilter = title;
      self.tagsForFilter = tags;
      self.filterFromDate = from;
      self.filterInterval = interval;
      self.indexPathForFilter = indexPath;

      self.isNewFilter = NO;
    } else {
      self.titleForFilter = nil;
      self.tagsForFilter = nil;
      self.filterFromDate = nil;
      self.filterInterval = nil;
      self.indexPathForFilter = nil;
    self.isNewFilter = YES;
    }
  }
  
  self.delegate = delegate;
  return self;
}

/**
 * @brief  テーブルのデータ
 *
 * @return データ配列
 */
-(NSArray *)dataArray
{
  NSArray *itemOne = @[ [self titleCellID] ];
  
  NSArray *itemTwo = @[kTagSelectCellID];

  NSArray *itemThree = @[kSwitchCellID];
  
//  NSArray *itemFour = @[kDueDateCellID, kDueDateCellID];

  dataArray_ = @[itemOne, itemTwo, itemThree];
  return dataArray_;
}

/**
 * @brief  パラメータを初期化・設定
 */
-(void)initParam
{
  self.indexPathForDatePickerCell = nil;
  didActivatedKeyboard_ = NO;
  
  // 最初は期間選択パネルを隠す
  indexPathsForSelectionPanel_ = nil;
  stateOfSwitchOne_ = YES;
  stateOfSwitchTwo_ = YES;
  stateOfSwitchThree_ = YES;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // パラメータを初期化・設定
  [self initParam];
  
  // セルを登録
  [self registerClassForCells];
  
  // テーブルの設定
  self.tableView.allowsMultipleSelectionDuringEditing = YES;

  // ナビバーの右に
  // 保存ボタンを作成する
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(saveAndDismissView)];
  self.navigationItem.rightBarButtonItem = addButton;
  
  // show short-style date format
  self.dateFormatter = [[NSDateFormatter alloc] init];
  [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
  [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
}

-(void)viewDidAppear:(BOOL)animated
{
  if (self.isNewFilter) {
    if (didActivatedKeyboard_ == NO) {
      [[self titleCell].titleField becomeFirstResponder];
      didActivatedKeyboard_ = YES;
    }
  }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  [[self titleCell].titleField resignFirstResponder];
}

-(void)saveAndDismissView
{
  LOG(@"保存してビュー削除");
  self.titleForFilter = [self titleCell].titleField.text;
  // デリゲートに入力情報を渡す
  [self.delegate dismissInputFilterView:self.titleForFilter
                        tagsForSelected:self.tagsForFilter
                                   from:self.filterFromDate
                               interval:self.filterInterval
                              indexPath:self.indexPathForFilter
                            isNewFilter:self.isNewFilter];
  
  // ビューをポップ
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ユーティリティ

-(void)didChangedDate:(NSDate *)date
{
  NSIndexPath *targetedCellIndexPath = nil;
  if ([self hasInlineDatePickerCell]) {
    // 上の日付セルを指定する
    targetedCellIndexPath = [NSIndexPath indexPathForRow:self.indexPathForDatePickerCell.row - 1
                                               inSection:2];
  } else {
    // external date picker: update the current "selected" cell's date.
    targetedCellIndexPath = [self.tableView indexPathForSelectedRow];
  }
  
  // TODO: update data model
  if (targetedCellIndexPath.row == 0) {
    self.filterFromDate = date;
  } else {
    self.filterInterval = date;
  }
  
  // updaate the cell's date string.
  UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
  cell.textLabel.text = [self.dateFormatter stringFromDate:date];
}
/**
 * @brief  指定した位置の下に日付ピッカーを持つか評価
 *
 * @param indexPath 位置
 *
 * @return 真偽値
 */
-(BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
  BOOL hasDatePicker = NO;
  
  NSInteger targetedRow = indexPath.row;
  targetedRow++;
  
  UITableViewCell *checkDatePickerCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow
                                                                                                  inSection:2]];
  UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
  hasDatePicker = (checkDatePicker != nil);
  
  return hasDatePicker;
}

/**
 * @brief  日付ピッカーの表示を保存している日付に合わせる
 */
- (void)updateDatePicker
{
  if (self.indexPathForDatePickerCell) {
    UITableViewCell *datePickerCell = [self.tableView cellForRowAtIndexPath:self.indexPathForDatePickerCell];
    
    UIDatePicker *targetedDatePicker = (UIDatePicker *)[datePickerCell viewWithTag:kDatePickerTag];
    if (targetedDatePicker) {
      [targetedDatePicker setDate:[NSDate date] animated:NO];
    }
  }
}

/**
 * @brief  指定した位置に日付ピッカーがあるか評価
 *
 * @param indexPath 位置
 *
 * @return 真偽値
 */
-(BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
  return ([self hasInlineDatePickerCell] && self.indexPathForDatePickerCell.row == indexPath.row);
}

/**
 * @brief  位置が日付を持つか評価
 *
 * @param indexPath 位置
 *
 * @return 真偽値
 */
-(BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
  BOOL hasDate = NO;
  if ([self cellIdentifierAtIndexPath:indexPath] == kDueDateCellID) {
    hasDate = YES;
  }
  return hasDate;
}

-(TitleCell *)titleCell
{
  NSIndexPath *indexPathForTitleCell = [NSIndexPath indexPathForRow:0
                                                          inSection:0];
  TitleCell *cell = (TitleCell *)[self.tableView cellForRowAtIndexPath:indexPathForTitleCell];
  return cell;
}
-(ItemDetailTagCell *)tagCell
{
  NSIndexPath *indexPathForTagCell = [NSIndexPath indexPathForRow:0
                                                        inSection:1];
  ItemDetailTagCell *cell = (ItemDetailTagCell *)[self.tableView cellForRowAtIndexPath:indexPathForTagCell];
  return cell;
}
/**
 * @brief  指定の位置のセルのIDを返す
 *
 * @param indexPath 位置
 *
 * @return IDの文字列
 */
-(NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier;
  if (indexPath.section == 2) {
    return kSwitchCellID;
  }
  if ([self hasInlineDatePickerCell]) {
    if (indexPath.section == 3) {
      if ([self indexPathHasPicker:indexPath]) {
        return kDatePickerCellID;
      } else {
        return kDueDateCellID;
      }
    }
    identifier = self.dataArray[indexPath.section][indexPath.row];
  } else {
    identifier = self.dataArray[indexPath.section][indexPath.row];
  }
  return identifier;
}

-(BOOL)isTitleCellAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self titleCellID] == [self cellIdentifierAtIndexPath:indexPath]) {
    return YES;
  } else {
    return NO;
  }
}

-(BOOL)isTagCellAtIndexPath:(NSIndexPath *)indexPath
{
  if (kTagSelectCellID == [self cellIdentifierAtIndexPath:indexPath]) {
    return YES;
  } else {
    return NO;
  }
}

- (BOOL)isDateCellAtIndexPath:(NSIndexPath *)indexPath
{
  if (kDueDateCellID == [self cellIdentifierAtIndexPath:indexPath]) {
    return YES;
  } else {
    return NO;
  }
}

- (BOOL)isDatePickerCellAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self hasInlineDatePickerCell]) {
    if (kDatePickerCellID == [self cellIdentifierAtIndexPath:indexPath]) {
      return YES;
    } else {
      return NO;
    }
  } else {
    return NO;
  }
  return NO;
}

/**
 * @brief  日付ピッカーが表示されているか評価する
 *
 * @return 真偽値
 */
- (BOOL)hasInlineDatePickerCell
{
  if (self.indexPathForDatePickerCell) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - 期間選択パネルユーティリティ

/**
 * @brief  期間選択パネルが表示されているか評価する
 *
 * @return 真偽値
 */
-(BOOL)hasInlineIntervalSelectionPanel
{
  // 期間選択パネル用のインデックスパス配列が存在すれば、真を返す
  // そうでなければ、偽を返す
  if (indexPathsForSelectionPanel_ == nil) {
    return NO;
  } else {
    return YES;
  }
}

/**
 * @brief  期限選択パネルを閉じる
 */
-(void)closeIntervalSelectionPanel
{
  // 期間選択パネルが表示されていれば、パネルを閉じる。
  // １番目のスイッチをオフにする。
  if ([self hasInlineIntervalSelectionPanel]) {
    NSArray *indexPaths = indexPathsForSelectionPanel_;
    indexPathsForSelectionPanel_ = nil;
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
    
    // １つ目のスイッチをオフにする
    stateOfSwitchOne_ = NO;
    [self updateSwitchDisplayWithAnimation:YES];
  }
}
/**
 * @brief  期限選択パネルを開く
 */
-(void)openIntervalSelectionPanel
{
  // 期間選択パネルが閉じていれば、パネルを開く。
  // 全てのスイッチをオンにする。
  if ( ! [self hasInlineIntervalSelectionPanel]) {
    indexPathsForSelectionPanel_ = @[ INDEX(1, 2),
                                      INDEX(2, 2) ];
    
    [self.tableView insertRowsAtIndexPaths:indexPathsForSelectionPanel_
                          withRowAnimation:UITableViewRowAnimationFade];
    
    // 期間選択パネルの全てをオンにする
    stateOfSwitchOne_ = YES;
    stateOfSwitchTwo_ = YES;
    stateOfSwitchThree_ = YES;
    [self updateSwitchDisplayWithAnimation:YES];
  }
}

/**
 * @brief  スイッチの状態を返す
 *
 * @param row スイッチの列
 *
 * @return 真偽値
 */
-(BOOL)stateOfSwitchWithRow:(NSInteger)row
{
  NSIndexPath *indexPath = INDEX(row,2);
  SwitchCell *cellTwo = (SwitchCell *)[self.tableView cellForRowAtIndexPath:indexPath];
  return cellTwo.switchView.on;
}

/**
 * @brief  スイッチの表示を現在の状態に更新する
 */
-(void)updateSwitchDisplayWithAnimation:(BOOL)animation
{
  SwitchCell *cellOne = (SwitchCell *)[self.tableView cellForRowAtIndexPath:INDEX(0, 2)];
  SwitchCell *cellTwo = (SwitchCell *)[self.tableView cellForRowAtIndexPath:INDEX(1, 2)];
  SwitchCell *cellThree = (SwitchCell *)[self.tableView cellForRowAtIndexPath:INDEX(2, 2)];
  [cellOne.switchView setOn:stateOfSwitchOne_ animated:animation];
  [cellTwo.switchView setOn:stateOfSwitchTwo_ animated:animation];
  [cellThree.switchView setOn:stateOfSwitchThree_ animated:animation];
}

/**
 * @brief  スイッチが変更された時の処理
 *
 * @param sender 変更されたスイッチ
 */
-(void)changedSwitchValueOne:(UISwitch *)sender
{
  // キーボードが開いていたら閉じる
  [[self titleCell].titleField resignFirstResponder];
  
  // スイッチの状態を記録する
  stateOfSwitchOne_ = sender.on;
  
  // スイッチがオンなら、
  // 期間選択パネルを開く
  // そうでないなら閉じる。
  if (stateOfSwitchOne_) {
    [self openIntervalSelectionPanel];
  } else {
    [self closeIntervalSelectionPanel];
  }
}
-(void)changedSwitchValueTwo:(UISwitch *)sender
{
  // キーボードが開いていたら閉じる
  [[self titleCell].titleField resignFirstResponder];
  
  // スイッチの状態を記録する
  stateOfSwitchTwo_ = sender.on;
  if (stateOfSwitchTwo_) {
    ;
  } else {
    // もし他方のスイッチもオフなら、選択パネルを閉じる
    if (stateOfSwitchThree_ == NO) {
      [self closeIntervalSelectionPanel];
    }
  }
}
-(void)changedSwitchValueThree:(UISwitch *)sender
{
  // キーボードが開いていたら閉じる
  [[self titleCell].titleField resignFirstResponder];
  
  // スイッチの状態を記録する
  stateOfSwitchThree_ = sender.on;
  if (stateOfSwitchThree_) {
    ;
  } else {
    // もし他方のスイッチもオフなら、選択パネルを閉じる
    if (stateOfSwitchTwo_ == NO) {
      [self closeIntervalSelectionPanel];
    }
  }
}
#pragma mark - テーブルビュー

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  NSInteger numRows = [self.dataArray[section] count];
  if ([self hasInlineIntervalSelectionPanel] && section == 2) {
    numRows += 2;
  }
  if ([self hasInlineDatePickerCell] && section == 3) {
    numRows += 1;
  }
  return numRows;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self indexPathHasPicker:indexPath]) {
    return CGRectGetHeight([[self.tableView dequeueReusableCellWithIdentifier:kDatePickerCellID] frame]);
  }
  return 44;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.dataArray count];
}

-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
  if (section == 0) {
    return @"TITLE";
  }
  if (section == 1) {
    return @"";
  }
  if (section == 2) {
    return @"";
  }
  if (section == 3) {
    return @"SEARCH";
  }
  return @"";
}

/**
 * @brief  セルを作成する
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 *
 * @return セル
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // セルのIDで場合分けする
  if ([self isTitleCellAtIndexPath:indexPath])
  {
    // タイトルセルを作成して返す
    TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:[self titleCellID]];
    cell.titleField.text = self.titleForFilter;
    cell.titleField.placeholder = @"title";
    cell.titleField.delegate = self;
    return cell;
  }
  else if ([self cellIdentifierAtIndexPath:indexPath] == kSwitchCellID)
  {
    // スイッチセルを作成して返す。
    // 列ごとにタイトルを変え、
    // セルを選択しても変化しないようにする
    SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:kSwitchCellID];
    
    NSString *title;
    SEL selector;
    if (indexPath.row == 0) {
      title = @"期限付";
      selector = @selector(changedSwitchValueOne:);
    } else if ([self hasInlineIntervalSelectionPanel] && indexPath.row == 1) {
      title = @"期限過";
      selector = @selector(changedSwitchValueTwo:);
    } else if ([self hasInlineIntervalSelectionPanel] && indexPath.row == 2) {
      title = @"今日";
      selector = @selector(changedSwitchValueThree:);
    } else {
      title = @"";
      selector = nil;
    }
    cell.textLabel.text = title;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 初めの一回だけターゲットを設定する
    if ([cell.switchView allTargets].count <= 0) {
      [cell.switchView addTarget:self
                          action:selector
                forControlEvents:UIControlEventValueChanged];
    }
    return cell;
  }
  else if ([self isTagCellAtIndexPath:indexPath])
  {
    // タグ選択セルを作成して返す
    ItemDetailTagCell *cell = [tableView dequeueReusableCellWithIdentifier:kTagSelectCellID];
    [self configureTagCell:cell
    atIndexPathInTableView:indexPath];
    return cell;
  }
  else if ([self indexPathHasDate:indexPath])
  {
    // 日付セルを作成して返す
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kDueDateCellID];
    if (indexPath.row == 0 && self.filterFromDate) {
      cell.textLabel.text = [self.dateFormatter stringFromDate:self.filterFromDate];
      return cell;
    }
    if (indexPath.row != 0 && self.filterInterval) {
      cell.textLabel.text = [self.dateFormatter stringFromDate:self.filterInterval];
      return cell;
    }
    cell.textLabel.text = @"date";
    return cell;
  }
  else if ([self indexPathHasPicker:indexPath])
  {
    // 日付ピッカーセルを作成して返す
    ItemDetailDatePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:kDatePickerCellID];
    cell.delegate = self;
    return cell;
  }
  UITableViewCell *cell;
  cell = [UITableViewCell new];
  return cell;
}

- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
  [self.tableView beginUpdates];
  
  NSArray *indexPaths = @[ [NSIndexPath indexPathForRow:indexPath.row+1
                                              inSection:2] ];
  if ([self hasPickerForIndexPath:indexPath]) {
    [self.tableView deleteRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
  } else {
    [self.tableView insertRowsAtIndexPaths:indexPaths
                          withRowAnimation:UITableViewRowAnimationFade];
  }
  [self.tableView endUpdates];
}


#pragma mark - 日付ピッカーユーティリティ

/**
 * @brief  日付ピッカーを表示する
 *
 * @param indexPath 位置
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.tableView beginUpdates];
  
  BOOL before = NO;
  if ([self hasInlineDatePickerCell]) {
    before = self.indexPathForDatePickerCell.row < indexPath.row;
  }
  BOOL sameCellClicked = (self.indexPathForDatePickerCell.row - 1 == indexPath.row);
  if ([self hasInlineDatePickerCell]) {
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.indexPathForDatePickerCell.row
                                                                inSection:2]]
                          withRowAnimation:UITableViewRowAnimationFade];
    self.indexPathForDatePickerCell = nil;
  }
  if (!sameCellClicked) {
    NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
    NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:2];
    
    [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
    self.indexPathForDatePickerCell = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1
                                                         inSection:2];
  }
  
  [self.tableView deselectRowAtIndexPath:indexPath
                                animated:YES];
  [self.tableView endUpdates];
}

#pragma mark 選択の処理

/**
 * @brief  セルが選択された時の処理
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 */
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self.tableView deselectRowAtIndexPath:indexPath
                                animated:YES];
  if ([self isTagCellAtIndexPath:indexPath])
  {
    // タグセル
    [self newTagSelectViewAndPush];
    return;
  }
  if ([self indexPathHasDate:indexPath]) {
    // 日付セル
    [self displayInlineDatePickerForRowAtIndexPath:indexPath];
  }
}

-(void)newTagSelectViewAndPush
{
  // タグ選択画面を作成して
  // プッシュする
  // タグの選択上限はなし
  self.titleForFilter = [self titleCell].titleField.text;
  TagSelectViewController *controller = [[TagSelectViewController alloc] initWithNibName:@"TagSelectViewController"
                                                                                  bundle:nil];
  controller.delegate = self;
  controller.tagsForAlreadySelected = self.tagsForFilter;
  controller.maxCapacityRowsForSelected = 0;
  
  UINavigationController *navcontroller = [[UINavigationController alloc] initWithRootViewController:controller];
  
  [self presentViewController:navcontroller
                     animated:YES
                   completion:^{
                   }];
}

-(void)dismissTagSelectView:(NSSet *)tagsForSelectedRows
{
  // 受け取ったタグのセットを
  // フィルターのタグセットとして
  // 一時記録する
  // テーブルをリロードする？？
  self.tagsForFilter = tagsForSelectedRows;
  
  [self.tableView reloadData];
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

#pragma mark セルの設定

-(void)configureTagCell:(ItemDetailTagCell *)cell
 atIndexPathInTableView:(NSIndexPath *)indexPathInTableView;
{
  NSString *stringForTags;
  if (self.tagsForFilter && [self.tagsForFilter count] > 0) {
    stringForTags = [self createStringForSet:self.tagsForFilter];
  } else {
    stringForTags = @"tags";
  }
  cell.textLabel.text = stringForTags;
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
