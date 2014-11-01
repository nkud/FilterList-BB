//
//  ListViewController.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

static NSString *kEditBarItemImageName = @"EditBarItem.png";

// ナビゲーションバータイトル文字サイズ
#define kTitleFontSize 18
#define kSubTitleFontSize 15

#pragma mark -

#import "ListViewController.h"
#import "Header.h"

@interface ListViewController ()

@end

@implementation ListViewController

#pragma mark - 初期化 -

/**
 * @brief  ビュー表示前処理
 *
 * @param animated アニメーション
 */
-(void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  // クリア
  [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow]
                                animated:YES];
  [self.tableView reloadData];
}

/**
 * @brief  ビュー非表示前
 *
 * @param animated アニメーション
 */
-(void)viewWillDisappear:(BOOL)animated
{
  [self hideEditTabBar:YES];
}

/**
 * @brief  ビュー表示後処理
 *
 * @param animated アニメーション
 */
- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  // スクロールバーを点滅させる
  [self.tableView flashScrollIndicators];
}

/**
 * @brief  ビューロード後処理
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
  
  // 編集時マルチ選択を許可
  self.tableView.allowsMultipleSelectionDuringEditing = YES;
  
  [self.view addSubview:self.tableView];
  
  // タブバー初期化
  frame = CGRectMake(0,
                     SCREEN_BOUNDS.size.height - TABBAR_H - NAVBAR_H - STATUSBAR_H,
                     SCREEN_BOUNDS.size.width,
                     TABBAR_H);
  
  self.tabBar = [[UITabBar alloc] initWithFrame:frame];
  self.tabBar.delegate = self;
  [self.view addSubview:self.tabBar];
  
  // 編集タブ初期化
  self.editTabBar = [[UIView alloc] initWithFrame:self.tabBar.frame];
  self.editTabBar.backgroundColor = [UIColor whiteColor];
  
  // 全削除ボタン作成
  self.deleteAllButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.deleteAllButton addTarget:self
                           action:@selector(deleteAllSelectedRows:)
                 forControlEvents:UIControlEventTouchUpInside];
  [self updateDeleteButton];
  [self.deleteAllButton setTintColor:[UIColor whiteColor]];
  CGFloat height = TABBAR_H;
  CGFloat width = SCREEN_BOUNDS.size.width/2;
  CGFloat margin = 0;
  [self.deleteAllButton setTitle:@"Delete All"
                        forState:UIControlStateDisabled];
  self.deleteAllButton.frame = CGRectMake(margin,
                                          (self.editTabBar.frame.size.height-height)/2,
                                          width,
                                          height);
  self.deleteAllButton.backgroundColor = [UIColor redColor];
  [self.editTabBar addSubview:self.deleteAllButton];
  
  [self.view addSubview:self.editTabBar];
  
  // 編集タブは隠す
  [self hideEditTabBar:YES];
}

/**
 * @brief  編集
 *
 * @param flag     編集中か評価
 * @param animated アニメーション
 */
//- (void)setEditing:(BOOL)flag
//          animated:(BOOL)animated {
//  
//  [super setEditing:flag
//           animated:animated];
//  
//  [self.tableView setEditing:flag
//                    animated:animated];
//}

/**
 * @brief  削除ボタンを更新する
 */
-(void)updateDeleteButton
{
  NSArray *selectedRows = [self.tableView indexPathsForSelectedRows];
  BOOL noItemsInTable = [[self.fetchedResultsController fetchedObjects] count] == 0;
  BOOL allItemsAreSelected = selectedRows.count == [[self.fetchedResultsController fetchedObjects] count];
  BOOL noItemsAreSelected = selectedRows.count == 0;
  NSString *title;
  
  if (noItemsInTable) {
    self.deleteAllButton.enabled = NO;
    return;
  } else {
    self.deleteAllButton.enabled = YES;
  }
  
  if (allItemsAreSelected || noItemsAreSelected) {
    title = @"Delete All";
  } else {
      title = [NSString stringWithFormat:@"Delete(%lu)", (unsigned long)selectedRows.count];
  }
  
  [self.deleteAllButton setTitle:title
                        forState:UIControlStateNormal];
}
-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self updateDeleteButton];
}
-(void)tableView:(UITableView *)tableView
didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [self updateDeleteButton];
}

-(void)deleteAllSelectedRows:(id)sender
{
  LOG(@"全削除");
  for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
    NSManagedObject *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [[self.fetchedResultsController managedObjectContext] deleteObject:item];
  }
}


#pragma mark - ユーティリティ -
#pragma mark ナビゲーションバー
-(UIBarButtonItem *)newInsertObjectButton
{
  UIBarButtonItem *insertObjectButton
  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                  target:self
                                                  action:@selector(didTappedInsertObjectButton)];
  return insertObjectButton;
}

/**
 * @brief  編集ボタンを作成
 *
 * @return インスタンス
 */
-(UIBarButtonItem *)newEditTableButton
{
  UIBarButtonItem *editTableButton
  = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:kEditBarItemImageName]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(didTappedEditTableButton)];
  editTableButton.tintColor = RGB(212, 212, 212);
  return editTableButton;
}

/**
 * @brief  編集ボタンをタップ時
 */
-(void)didTappedEditTableButton
{
  [self updateDeleteButton];
  if (self.tableView.isEditing)
  {
    // 編集中なら
    // タブバーを開く
    [self.delegateForList openTabBar];
    [self hideEditTabBar:YES];
  } else {
    // そうでないなら
    // タブバーを閉じる
    [self hideEditTabBar:NO];
    [self.delegateForList closeTabBar];
  }
}

-(void)didTappedInsertObjectButton
{
  [self.delegateForList closeTabBar];
  LOG(@"挿入ボタン");
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
  self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 20)];
  self.titleLabel.font = [UIFont boldSystemFontOfSize:kTitleFontSize];
  self.titleLabel.text = title;
  self.titleLabel.textColor = [UIColor blackColor];
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.backgroundColor = [UIColor clearColor];
  [self.titleView addSubview:self.titleLabel];
  
  // サブタイトルを作成・設定
  self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 195, 20)];
  self.subTitleLabel.font = [UIFont boldSystemFontOfSize:kSubTitleFontSize];
  self.subTitleLabel.textColor = [UIColor blackColor];
  self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
  self.subTitleLabel.backgroundColor = [UIColor clearColor];
  self.subTitleLabel.adjustsFontSizeToFitWidth = YES;
  self.subTitleLabel.text = subTitle;
  [self.titleView addSubview:self.subTitleLabel];
}

/**
 * @brief  メッセージを表示する
 *
 * @param message メッセージ
 */
-(void)aleartMessage:(NSString *)message
{
  CGFloat duration = 0.3f;
  CGFloat presentDistance = 50;
  CGFloat delay = 0.8f;
  
  UILabel *label = self.subTitleLabel;
  
  CGRect originFrame = label.frame;
  CGRect startFrame = label.frame;
  startFrame.origin.x -= presentDistance;
  CGRect destinationFrame = label.frame;
  destinationFrame.origin.x += presentDistance;
//  NSString *originString = label.text;
  
  // メッセージ
  UILabel *mesLabel = [[UILabel alloc] initWithFrame:startFrame];
  mesLabel.font = [UIFont boldSystemFontOfSize:kSubTitleFontSize];
  mesLabel.textColor = [UIColor blackColor];
  mesLabel.textAlignment = NSTextAlignmentCenter;
  mesLabel.backgroundColor = [UIColor clearColor];
  mesLabel.adjustsFontSizeToFitWidth = YES;
  mesLabel.text = message;
  mesLabel.alpha = 0;
  
  [self.titleView addSubview:mesLabel];
  
  // 消滅
  [UIView animateWithDuration:duration
                   animations:^{
                     label.alpha = 0;
                     label.frame = destinationFrame;
                     
                     mesLabel.alpha = 1;
                     mesLabel.frame = originFrame;
                   }
                   completion:^(BOOL finished) {
                     label.frame = startFrame;
                     
                     // 出現
                     [UIView animateWithDuration:0.2
                                           delay:delay
                                         options:UIViewAnimationOptionCurveLinear
                                      animations:^{
                                        label.alpha = 1;
                                        label.frame = originFrame;
                                        
                                        mesLabel.alpha = 0;
                                        mesLabel.frame = destinationFrame;
                                      }
                                      completion:^(BOOL finished) {
                                        ;
                                      }];
                     
                   }];
}

#pragma mark アクセサリー
//-(UIButton *)newDisclosureIndicatorAccessory
//{
//  UIButton *disclosureIndicator = [UIButton buttonWithType:UIButtonTypeCustom];
//  disclosureIndicator.frame = CGRectMake(0, 0, 30, 30);
//  disclosureIndicator.backgroundColor = [UIColor blackColor];
//  [disclosureIndicator addTarget:self
//                          action:@selector(didTappedAccessoryButton)
//                forControlEvents:UIControlEventTouchUpInside];
//  return disclosureIndicator;
//}

/**
 * @brief  アクセサリーがタップされた時の処理
 */
-(void)didTappedAccessoryButton
{
  LOG(@"アクセサリーをタップ");
}

#pragma mark タブバー

/**
 * @brief  編集タブバーの表示・非表示
 *
 * @param hide 真偽値
 */
-(void)hideEditTabBar:(BOOL)hide
{
  CGFloat duration = 0.2;
  CGRect frame = self.editTabBar.frame;
  if (hide) {
    // 編集タブを隠す
    frame.origin.y = SCREEN_BOUNDS.size.height - NAVBAR_H - STATUSBAR_H;
  } else {
    // 編集タブを表示する
    frame.origin.y = SCREEN_BOUNDS.size.height - TABBAR_H - NAVBAR_H - STATUSBAR_H;
  }
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:duration];
  self.editTabBar.frame = frame;
  [UIView commitAnimations];
}

#pragma mark - その他 -
#pragma mark メモリー
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - テーブルビュー -

#pragma mark デリゲート

#pragma mark データソース

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
