//
//  TagDetailViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/19.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "TagDetailViewController.h"
#import "Header.h"

@interface TagDetailViewController ()

@end

@implementation TagDetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  // テーブルビュー初期化
  CGRect frame = CGRectMake(0,
                            0,
                            SCREEN_BOUNDS.size.width,
                            SCREEN_BOUNDS.size.height - TABBAR_H - NAVBAR_H - STATUSBAR_H);
  self.tableView = [[UITableView alloc] initWithFrame:frame];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [[UITableViewCell alloc] init];
  return cell;
}

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
