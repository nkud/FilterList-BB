//
//  ConfigViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/11/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ConfigViewController.h"

#import "Header.h"
#import "Configure.h"

// ナビバーに表示するタイトル
static NSString *kNavBarTitle = @"Settings";
static NSString *kTitleCellID = @"TitleCellIdentifier";
static NSString *kTitleCellNibName = @"TitleCell";
static NSString *kNormalCellID = @"NormalCell";

#pragma mark -

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
//  [super viewDidLoad];
  
  // Do any additional setup after loading the view.
  CGRect tableFrame = SCREEN_BOUNDS;
//  tableFrame.size.height -= NAVBAR_H + STATUSBAR_H;
  self.tableView = [[UITableView alloc] initWithFrame:tableFrame
                                                style:UITableViewStyleGrouped];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
  
  // セルを登録
  [self.tableView registerNib:[UINib nibWithNibName:kTitleCellNibName
                                             bundle:nil]
       forCellReuseIdentifier:kTitleCellID];
  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:kNormalCellID];
  
  // キャンセルボタン
  self.navigationItem.leftBarButtonItem
  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(cancel:)];
  // タイトルを設定する
  self.navigationItem.title = kNavBarTitle;
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
  NSArray *colorSection = @[[self normalCellID]];
  NSArray *badgeSection = @[[self normalCellID]];
  NSArray *aboutSection = @[[self normalCellID]];
  dataArray_ = @[colorSection, badgeSection, aboutSection];
  return dataArray_;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
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
  NSString *identifier = self.dataArray[indexPath.section][indexPath.row];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
  [self configureCell:cell
          atIndexPath:indexPath];
  return cell;
}

-(NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
  if (section == 2) {
    return @"その他";
  }
  return @"未定";
}

/**
 * @brief  セルを設定する
 *
 * @param cell      セル
 * @param indexPath 位置
 */
-(void)configureCell:(UITableViewCell *)cell
         atIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.section == 2) {
    cell.textLabel.text = @"About FilterList";
  }
  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath
                           animated:YES];
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
