//
//  ListViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/09/23.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "ListViewController.h"
#import "Header.h"

@interface ListViewController ()

@end

@implementation ListViewController

#pragma mark - 初期化 -

/**
 * @brief  タイトルを設定
 *
 * @param title     メインタイトル
 * @param miniTitle サブタイトル
 */
-(void)configureTitleWithString:(NSString *)title
                       subTitle:(NSString *)subTitle
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
  UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 195, 20)];
  subTitleLabel.font = [UIFont boldSystemFontOfSize:10.0f];
  subTitleLabel.textColor = [UIColor grayColor];
  subTitleLabel.textAlignment = NSTextAlignmentCenter;
  subTitleLabel.backgroundColor = [UIColor clearColor];
  subTitleLabel.adjustsFontSizeToFitWidth = YES;
  subTitleLabel.text = subTitle;
  [self.titleView addSubview:subTitleLabel];
}

/**
 * @brief  ビュー読込後の処理
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  LOG(@"デリゲートを自身に設定");
  [self.tableView setDelegate:self];
}

#pragma mark - その他 -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - テーブル -

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell;
  return cell;
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
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
