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

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  // セルデータを作成
  NSArray *colorSection = @[[self titleCellID]];
  dataArray_ = @[colorSection];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [dataArray_ count];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  return [dataArray_[section] count];
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
