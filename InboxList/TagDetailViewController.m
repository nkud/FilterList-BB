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
    cell.titleField.text = @"fdsa";
    return cell;
  } else {
    UITableViewCell *cell;
    return cell;
  }
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
