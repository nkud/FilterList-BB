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

#import "ItemDetailTagCell.h"

#import "TagSelectViewController.h"

#import "Header.h"

#pragma mark Cell Identifier
static NSString *kTagSelectCellID = @"tagCell";
static NSString *kDueDateCellID = @"DueDateCell";
static NSString *kSearchCellID = @"SearchCell";

static NSString *kTagCellNibName = @"ItemDetailTagCell";

#pragma mark -

@interface FilterDetailViewController ()

@end

@implementation FilterDetailViewController

#pragma mark - 初期化

/**
 * @brief  セルを登録
 */
-(void)registerClassForCells
{
  [self.tableView registerNib:[UINib nibWithNibName:kTagCellNibName bundle:nil]
       forCellReuseIdentifier:kTagSelectCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kDueDateCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kSearchCellID];
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
                       isNewFilter:(BOOL)isNewFilter
                         indexPath:(NSIndexPath *)indexPath
                          delegate:(id<FilterDetailViewControllerDelegate>)delegate
{
  self = [super initWithNibName:nil bundle:nil];
  if (self) {
    if (title) {
      self.titleForFilter = title;
      self.tagsForFilter = tags;
      self.indexPathForFilter = indexPath;
      self.isNewFilter = NO;
    } else {
      self.titleForFilter = nil;
      self.tagsForFilter = nil;
      self.indexPathForFilter = nil;
    self.isNewFilter = YES;
    }
  }
  
  self.delegate = delegate;
  return self;
}

/**
 * @brief  パラメータを初期化・設定
 */
-(void)initParam
{
  NSArray *itemOne = @[ [self titleCellID] ];
  NSArray *itemTwo = @[kTagSelectCellID];
  NSArray *itemThree = @[kDueDateCellID];
  NSArray *itemFour = @[kSearchCellID];
  dataArray_ = @[itemOne, itemTwo, itemThree, itemFour];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // パラメータを初期化・設定
  [self initParam];
  

  // セルを登録
  [self registerClassForCells];
  
  // テーブルの設定
  self.tableView.allowsMultipleSelectionDuringEditing = YES; // ???
  self.tableView.scrollEnabled = NO;

  // ボタンを設定
  UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                target:self
                                action:@selector(saveAndDismissView)];

  self.navigationItem.rightBarButtonItem = addButton;
}

-(void)viewDidAppear:(BOOL)animated
{
  if (self.isNewFilter) {
    [[self titleCell].titleField becomeFirstResponder];
  }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self saveAndDismissView];
  return YES;
}

-(void)saveAndDismissView
{
  LOG(@"保存してビュー削除");
  self.titleForFilter = [self titleCell].titleField.text;
  // デリゲートに入力情報を渡す
  [self.delegate dismissInputFilterView:self.titleForFilter
                        tagsForSelected:self.tagsForFilter
                              indexPath:self.indexPathForFilter
                            isNewFilter:self.isNewFilter];
  
  // ビューをポップ
  [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - ユーティリティ
-(TitleCell *)titleCell
{
  NSIndexPath *indexPathForTitleCell = [NSIndexPath indexPathForRow:0
                                                          inSection:0];
  TitleCell *cell = (TitleCell *)[self.tableView cellForRowAtIndexPath:indexPathForTitleCell];
  return cell;
}
-(ItemDetailTagCell *)tagCell
{
  NSIndexPath *indexPathForTagCell = [NSIndexPath indexPathForRow:0 inSection:1];
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
  NSString *identifier = dataArray_[indexPath.section][indexPath.row];
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

#pragma mark - テーブルビュー

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  // タイトルセル
  if ([self isTitleCellAtIndexPath:indexPath]) {
    TitleCell *cell = [tableView dequeueReusableCellWithIdentifier:[self titleCellID]];
    cell.titleField.text = self.titleForFilter;
    cell.titleField.placeholder = @"title";
    cell.titleField.delegate = self;
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

#pragma mark 選択の処理

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isTagCellAtIndexPath:indexPath]) {
    LOG(@"タグセルを選択");
    [self newTagSelectViewAndPush];
  }
  [self.tableView deselectRowAtIndexPath:indexPath
                                animated:YES];
}

-(void)newTagSelectViewAndPush
{
  LOG(@"タグ選択画面を作成してプッシュ");
  self.titleForFilter = [self titleCell].titleField.text;
  TagSelectViewController *controller = [[TagSelectViewController alloc] initWithNibName:@"TagSelectViewController"
                                                                                  bundle:nil];
  controller.delegate = self;
  controller.tagsForAlreadySelected = nil;
  controller.maxCapacityRowsForSelected = 0;
  
  UINavigationController *navcontroller = [[UINavigationController alloc] initWithRootViewController:controller];
  
  [self presentViewController:navcontroller
                     animated:YES
                   completion:^{
                   }];
  
//  [self presentViewController:controller
//                     animated:YES
//                   completion:^{
//                     ;
//                   }];
//  [self.navigationController pushViewController:controller
//                                       animated:YES];
}

-(void)dismissTagSelectView:(NSSet *)tagsForSelectedRows
{
  LOG(@"タグが選択された");
  self.tagsForFilter = tagsForSelectedRows;
  
  [self.tableView reloadData];
//  [self dismissViewControllerAnimated:YES
//                           completion:^{
//                             ;
//                           }];
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
