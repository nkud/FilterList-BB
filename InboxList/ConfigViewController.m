//
//  ConfigViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/11/03.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "ConfigViewController.h"

@interface ConfigViewController ()
{
  NSArray *dataArray_;
}

@end

@implementation ConfigViewController

/**
 * @brief  ビューロード後処理
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // キャンセルボタン
  self.navigationItem.leftBarButtonItem
  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(cancel:)];
  
  // タイトル
  self.navigationItem.title = @"Configure";
}

- (void)cancel:(id)sender
{
  [self dismissViewControllerAnimated:YES
                           completion:nil];
}

/**
 * @brief  データ配列
 *
 * @return 配列
 */
-(NSArray *)dataArray
{
  // セルデータを作成
  NSArray *colorSection = @[[self titleCellID]];
  NSArray *badgeSection = @[[self titleCellID]];
  dataArray_ = @[colorSection, badgeSection];
  return dataArray_;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  return [self.dataArray[section] count];
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
