//
//  InputFilterViewController2.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/12.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "InputFilterViewController.h"
#import "FilterCell.h"
#import "CoreDataController.h"

#import "ItemDetailTitleCell.h"
#import "ItemDetailTagCell.h"

#import "TagSelectViewController.h"

#import "Header.h"

#pragma mark Cell Identifier
static NSString *kTitleCellID = @"titleCell";
static NSString *kTagSelectCellID = @"TagSelectCell";
static NSString *kDueDateCellID = @"DueDateCell";
static NSString *kSearchCellID = @"SearchCell";

static NSString *kTitleCellNibName = @"ItemDetailTitleCell";

#pragma mark -

@interface InputFilterViewController ()
{
  NSArray *dataArray_;
}

@end

@implementation InputFilterViewController

#pragma mark - 初期化

/**
 * @brief  セルを登録
 */
-(void)registerClassForCells
{
  [self.tableView registerNib:[UINib nibWithNibName:kTitleCellNibName bundle:nil]
       forCellReuseIdentifier:kTitleCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kTagSelectCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kDueDateCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kSearchCellID];
}

/**
 * @brief  パラメータを初期化・設定
 */
-(void)initParam
{
  NSArray *itemOne = @[kTitleCellID];
  NSArray *itemTwo = @[kTagSelectCellID];
  NSArray *itemThree = @[kDueDateCellID];
  NSArray *itemFour = @[kSearchCellID];
  dataArray_ = @[itemOne, itemTwo, itemThree, itemFour];

  self.titleForFilter = nil;
  self.tagsForFilter = nil;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // パラメータを初期化・設定
  [self initParam];
  
  // テーブルビュー初期化
  self.tableView = [[UITableView alloc] initWithFrame:SCREEN_BOUNDS
                                                style:UITableViewStyleGrouped];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
  
  // セルを登録
  [self registerClassForCells];
  
  // テーブルの設定
  self.tableView.allowsMultipleSelectionDuringEditing = YES;
  self.tableView.scrollEnabled = NO;

  // ボタンを設定
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(saveAndDismissView)];
  self.navigationItem.rightBarButtonItem = addButton;
}

-(ItemDetailTitleCell *)titleCell
{
  NSIndexPath *indexPathForTitleCell = [NSIndexPath indexPathForRow:0
                                                          inSection:0];
  ItemDetailTitleCell *cell = (ItemDetailTitleCell *)[self.tableView cellForRowAtIndexPath:indexPathForTitleCell];
  return cell;
}
-(ItemDetailTagCell *)tagCell
{
  NSIndexPath *indexPathForTagCell = [NSIndexPath indexPathForRow:0 inSection:1];
  ItemDetailTagCell *cell = (ItemDetailTagCell *)[self.tableView cellForRowAtIndexPath:indexPathForTagCell];
  return cell;
}

-(void)saveAndDismissView
{
  LOG(@"保存してビュー削除");
  self.titleForFilter = [self titleCell].titleField.text;
  // デリゲートに入力情報を渡す
  [self.delegate dismissInputFilterView:self.titleForFilter
                        tagsForSelected:self.tagsForFilter];
  
  // ビューをポップ
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ユーティリティ

/**
 * @brief  指定の位置のセルのIDを返す
 *
 * @param indexPath 位置
 *
 * @return IDの文字列
 */
-(NSString *)cellIdentifierAtIndexPath:(NSIndexPath *)indexPath
{
  NSString *identifier = dataArray_[indexPath.section][indexPath.row];
  return identifier;
}

-(BOOL)isTitleCellAtIndexPath:(NSIndexPath *)indexPath
{
  if (kTitleCellID == [self cellIdentifierAtIndexPath:indexPath]) {
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

#pragma mark - テーブルビュー

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // アイテムセル
  if ([self isTitleCellAtIndexPath:indexPath]) {
    ItemDetailTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:kTitleCellID];
    cell.titleField.text = @"title";
    return cell;
  }
  // タグ選択セル
  if ([self isTagCellAtIndexPath:indexPath]) {
    ItemDetailTagCell *cell = [tableView dequeueReusableCellWithIdentifier:kTagSelectCellID];
    [self configureTagCell:cell
    atIndexPathInTableView:indexPath];
    return cell;
  }
  UITableViewCell *cell;
  cell = [[UITableViewCell alloc] init];
  return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [dataArray_ count];;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  return [dataArray_[section] count];
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isTagCellAtIndexPath:indexPath]) {
    LOG(@"タグセルを選択");
    [self presentTagSelectView];
  }
  [self.tableView deselectRowAtIndexPath:indexPath
                                animated:YES];
}

-(void)presentTagSelectView
{
  TagSelectViewController *controller = [[TagSelectViewController alloc] initWithNibName:@"TagSelectViewController"
                                                                                  bundle:nil];
  controller.delegate = self;
  controller.tagsForAlreadySelected = nil;
  controller.maxCapacityRowsForSelected = 0;
  [self.navigationController pushViewController:controller
                                       animated:YES];
}

-(void)dismissTagSelectView:(NSSet *)tagsForSelectedRows
{
  LOG(@"タグが選択された");
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
