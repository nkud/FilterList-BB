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

@end

@implementation InputFilterViewController2

#pragma mark - 初期化

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.tableView = [[UITableView alloc] initWithFrame:SCREEN_BOUNDS];
  [self.view addSubview:self.tableView];
  
  // セルを登録
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kTitleCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kTagSelectCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kDueDateCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kSearchCellID];
  
  self.tagFetchedResultsController = [CoreDataController tagFetchedResultsController:self];
  
  // テーブルの設定
  self.tableView.allowsMultipleSelectionDuringEditing = YES;
  
//  // ボタンを設定
//  [self.saveButton addTarget:self
//                      action:@selector(dismissView)
//            forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ユーティリティ

#pragma mark - テーブルビュー
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  return cell;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  return 1;
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
