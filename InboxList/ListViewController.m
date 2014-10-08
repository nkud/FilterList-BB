//
//  ListViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ListViewController.h"
#import "Header.h"

@interface ListViewController ()

@end

@implementation ListViewController

#pragma mark - 初期化 -

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil
                         bundle:nibBundleOrNil];

  if (self) {

  }
  return self;
}

-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  // クリア
  [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                animated:YES];
  [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  // スクロールバーを点滅させる
  [self.tableView flashScrollIndicators];
}

- (void)setEditing:(BOOL)flag
          animated:(BOOL)animated {
  
  [super setEditing:flag
           animated:animated];

  [self.tableView setEditing:flag
                    animated:animated];
}
/**
 * @brief  ビューロード後
 */
- (void)viewDidLoad {
  [super viewDidLoad];
  
  // テーブルビュー初期化
  LOG(@"テーブルビュー初期化");
  CGRect frame = CGRectMake(0,
                            0,
                            SCREEN_BOUNDS.size.width,
                            SCREEN_BOUNDS.size.height - TABBAR_H - NAVBAR_H - STATUSBAR_H);
  self.tableView = [[UITableView alloc] initWithFrame:frame];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.view addSubview:self.tableView];
  
  // タブバー初期化
  LOG(@"タブバー初期化");
  frame = CGRectMake(0,
                     SCREEN_BOUNDS.size.height - TABBAR_H - NAVBAR_H - STATUSBAR_H,
                     SCREEN_BOUNDS.size.width,
                     TABBAR_H);
  
  self.tabBar = [[UITabBar alloc] initWithFrame:frame];
  self.tabBar.delegate = self;
  [self.view addSubview:self.tabBar];
  
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/**
 * @brief  タイトルを設定
 *
 * @param title     メインタイトル
 * @param miniTitle サブタイトル
 */
-(void)configureTitleWithString:(NSString *)title
                       subTitle:(NSString *)subTitle
{
  LOG(@"ナビゲーションバーのタイトル・サブタイトルを設定");
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
#pragma mark - その他

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"
                                                          forIndexPath:indexPath];
  
  // Configure the cell...
  
  return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
