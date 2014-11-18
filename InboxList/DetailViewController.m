//
//  DetailViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/22.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "DetailViewController.h"
#import "Header.h"

#define CANCEL_BUTTON_HEIGHT 44

static NSString *kCancelButtonImageName = @"cancel@2x.png";

static NSString *kTitleCellID = @"TitleCellIdentifier";
static NSString *kTitleCellNibName = @"TitleCell";

static NSString *kNormalCellID = @"NormalCell";

#pragma mark -

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - 初期化 -

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  self.tableView = [[UITableView alloc] initWithFrame:SCREEN_BOUNDS
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSArray *)dataArray
{
  dataArray_ = @[];
  return dataArray_;
}

#pragma mark - ユーティリティ -
-(NSString *)titleCellID
{
  return kTitleCellID;
}

-(NSString *)normalCellID
{
  return kNormalCellID;
}

- (void)addCancelButton:(UITableViewCell *)cell
{
  UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0,
                                                                      0,
                                                                      CANCEL_BUTTON_HEIGHT,
                                                                      CANCEL_BUTTON_HEIGHT)];
  [cancelButton setImage:[UIImage imageNamed:kCancelButtonImageName]
                forState:UIControlStateNormal];
  [cancelButton addTarget:self
                   action:@selector(didTappedCancelButton:)
         forControlEvents:UIControlEventTouchUpInside];
  cell.accessoryView = cancelButton;
}

- (void)didTappedCancelButton:(id)sender
{
  LOG(@"キャンセルボタン");
}

#pragma mark - テーブルビュー -
#pragma mark デリゲート
-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [UITableViewCell new];
  return cell;
}
#pragma mark データソース
-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
  return [self.dataArray[section] count];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return [self.dataArray count];
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
