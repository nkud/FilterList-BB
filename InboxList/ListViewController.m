//
//  ListViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/09/23.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "ListViewController.h"

@interface ListViewController ()

@end

@implementation ListViewController

/**
 * @brief  タイトルを設定
 *
 * @param title     メインタイトル
 * @param miniTitle サブタイトル
 */
-(void)configureTitleWithString:(NSString *)title
                      miniTitle:(NSString *)miniTitle
{
  // タイトルビューを再設定
  self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
  self.titleView.backgroundColor = [UIColor clearColor];
  self.titleView.opaque = NO;
  self.navigationItem.titleView = self.titleView;

  // メインタイトルを作成・設定
  UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 20)];
  titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
  titleLabel.text = title;
  titleLabel.textColor = [UIColor blackColor];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.backgroundColor = [UIColor clearColor];
  [self.titleView addSubview:titleLabel];

  // サブタイトルを作成・設定
  UILabel *miniTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 195, 20)];
  miniTitleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
  miniTitleLabel.textColor = [UIColor grayColor];
  miniTitleLabel.textAlignment = NSTextAlignmentCenter;
  miniTitleLabel.backgroundColor = [UIColor clearColor];
  miniTitleLabel.adjustsFontSizeToFitWidth = YES;
  miniTitleLabel.text = miniTitle;
  [self.titleView addSubview:miniTitleLabel];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  // タイトルビューを初期化
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return 0;
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
