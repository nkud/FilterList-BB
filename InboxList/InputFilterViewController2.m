//
//  InputFilterViewController2.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/12.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "InputFilterViewController2.h"
#import "FilterCell.h"
#import "CoreDataController.h"

#import "Header.h"

#pragma mark Cell Identifier
static NSString *kTitleCellID = @"TitleCell";
static NSString *kTagSelectCellID = @"TagSelectCell";
static NSString *kDueDateCellID = @"DueDateCell";
static NSString *kSearchCellID = @"SearchCell";

#pragma mark -

@interface InputFilterViewController2 ()
{
  NSArray *dataArray_;
}

@end

@implementation InputFilterViewController2

#pragma mark - 初期化

-(void)registerClassForCells
{
  [self.tableView registerClass:[UITableViewCell class]
          forCellReuseIdentifier:kTitleCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kTagSelectCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kDueDateCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kSearchCellID];
}

-(void)initParam
{
  dataArray_ = [NSArray arrayWithObjects:kTitleCellID, kTagSelectCellID, kDueDateCellID, kSearchCellID, nil];
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
  
//  // ボタンを設定
//  [self.saveButton addTarget:self
//                      action:@selector(dismissView)
//            forControlEvents:UIControlEventTouchUpInside];
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
  NSString *identifier = dataArray_[indexPath.row];
  return identifier;
}

#pragma mark - テーブルビュー

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:[self cellIdentifierAtIndexPath:indexPath]];
  return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  return [dataArray_ count];
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
