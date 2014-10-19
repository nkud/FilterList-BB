//
//  TagDetailViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/19.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "TagDetailViewController.h"
#import "Header.h"

#import "TagTitleCell.h"

static NSString *kTitleCellID = @"TitleCellIdentifier";
static NSString *kTitleCellNibName = @"TagTitleCell";

#pragma mark -

@interface TagDetailViewController () {
  NSArray *dataArray_;
}

@end

@implementation TagDetailViewController

#pragma mark - 初期化 -

-(instancetype)initWithTitle:(NSString *)title
                   indexPath:(NSIndexPath *)indexPath
                    delegate:(id<TagDetailViewControllerDelegte>)delegate
{
  self = [super initWithNibName:nil
                         bundle:nil];
  if (self) {
    if (title) {
      self.tagTitle = title;
      self.tagIndexPath = indexPath;
      self.isNewTag = NO;
    } else {
      self.tagTitle = nil;
      self.tagIndexPath = nil;
      self.isNewTag = YES;
    }
  }
  self.delegate = delegate;
  
  return self;
}

-(void)viewDidAppear:(BOOL)animated
{
  [[self tagTitleCell].titleField becomeFirstResponder];
}

/**
 * @brief  変数初期化
 */
- (void)initParam {
  NSArray *itemOne = @[kTitleCellID];
  dataArray_ = @[itemOne];
}

/**
 * @brief  ビューロード後の処理
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // 変数初期化
  [self initParam];
  // Do any additional setup after loading the view.
  
  // テーブルビュー初期化
  CGRect frame = CGRectMake(0,
                            0,
                            SCREEN_BOUNDS.size.width,
                            SCREEN_BOUNDS.size.height - TABBAR_H - NAVBAR_H - STATUSBAR_H);
  self.tableView = [[UITableView alloc] initWithFrame:frame
                                                style:UITableViewStyleGrouped];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
  
  [self.tableView registerNib:[UINib nibWithNibName:kTitleCellNibName bundle:nil]
       forCellReuseIdentifier:kTitleCellID];
  
  // ナビバーアイテム
  UIBarButtonItem *saveButton
  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                  target:self
                                                  action:@selector(saveAndDismiss)];
  self.navigationItem.rightBarButtonItem = saveButton;
}

/**
 * @brief  保存して終了
 */
- (void)saveAndDismiss
{
  LOG(@"タグを保存");
  
  self.tagTitle = [self tagTitleCell].titleField.text;
  
  [self.delegate dismissDetailView:self.tagTitle
                         indexPath:self.tagIndexPath
                          isNewTag:self.isNewTag];
  [self.navigationController popToRootViewControllerAnimated:YES];
}

- (TagTitleCell *)tagTitleCell
{
  TagTitleCell *cell
  = (TagTitleCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:0
                                                                              inSection:0]];
  return cell;
}

#pragma mark - ユーティリティ -
- (BOOL)isTitleCellAtIndexPath:(NSIndexPath *)atIndexPath
{
  if (atIndexPath == [NSIndexPath indexPathForRow:0 inSection:0]) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - テーブルビュー -
#pragma mark デリゲート

#pragma mark データソース


-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  return [dataArray_[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [dataArray_ count];
}

/**
 * @brief  セルを作成する
 *
 * @param tableView テーブルビュー
 * @param indexPath 位置
 *
 * @return インスタンス
 */
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if ([self isTitleCellAtIndexPath:indexPath])
  {
    TagTitleCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kTitleCellID];
    if (self.tagTitle) {
      cell.titleField.text = self.tagTitle;
    }
    cell.titleField.delegate = self;
    return cell;
  } else {
    UITableViewCell *cell;
    return cell;
  }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [textField resignFirstResponder];
  [self saveAndDismiss];
  return YES;
}

#pragma mark - その他 -
#pragma mark メモリー

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
