//
//  MainViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "Header.h"
#import "InputFilterViewController.h"
#import "CoreDataController.h"
#import "Configure.h"
#import "ListViewController.h"

#define kMarginRateForTagList 0
#define kMarginRateForFilterList 0

#pragma mark -

@interface MainViewController () {

}

@end


@implementation MainViewController

#pragma mark - 初期化

/**
*  @brief  パラメータを初期化
*/
- (void)initParameter
{
  swipe_distance = SWIPE_DURATION;
}

/**
 *  @brief  初期化
 *
 *  @return インスタンス
 */
-(id)init
{
  self = [super init];
  return self;
}

/**
 *  @brief  ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // パラメータを初期化
  [self initParameter];

  // タブバー初期化
  self.tabBar = [[TabBar alloc] initWithFrame:CGRectMake(0,
                                                         SCREEN_BOUNDS.size.height-TABBAR_H,
                                                         SCREEN_BOUNDS.size.width,
                                                         TABBAR_H)];
  self.tabBar.delegate = self;

  // アイテムビューコントローラを初期化
//  self.itemViewController = [[ItemViewController alloc] initWithStyle:UITableViewStylePlain];
  self.itemViewController = [[ItemViewController alloc] initWithNibName:@"ListViewController"
                                                                 bundle:nil];

  self.itemViewController.fetchedResultsController = [CoreDataController itemFethcedResultsController:self.itemViewController];
  
  self.itemNavigationController = [[ItemNavigationController alloc] initWithRootViewController:self.itemViewController];

  // フィルターコントローラを初期化
  self.filterViewController = [[FilterViewController alloc] initWithNibName:nil bundle:nil];
  self.filterViewController.delegate = self;
  self.filterViewController.fetchedResultsController = [CoreDataController filterFetchedResultsController:self.filterViewController];
  self.filterNavigationController = [[FilterNavigationController alloc] initWithRootViewController:self.filterViewController];
  
  // タグビューコントローラを初期化
  self.tagViewController = [[TagViewController alloc] initWithNibName:@"ListViewController"
                                                               bundle:nil];
  self.tagViewController.delegate = self;
  self.tagViewController.fetchedResultsController = [CoreDataController tagFetchedResultsController:self.tagViewController];
  self.tagNavigationController = [[TagNavigationController alloc] initWithRootViewController:self.tagViewController];
  
  // コントローラーを配置
  [self.view addSubview:self.itemNavigationController.view];
  [self.view addSubview:self.tagNavigationController.view];
  [self.view addSubview:self.filterNavigationController.view];
  [self.view addSubview:self.tabBar];
  
  [self closeTagListMode];
  [self closeFilterListMode];
  
  // リストのサイズを変更
  CGRect rect =  self.filterNavigationController.view.frame;
  rect.size.width = SCREEN_BOUNDS.size.width * ( 1.0 - kMarginRateForTagList );
  self.tagNavigationController.view.frame = rect;
  rect =  self.filterNavigationController.view.frame;
  rect.size.width = SCREEN_BOUNDS.size.width * ( 1.0 - kMarginRateForFilterList );
  self.filterNavigationController.view.frame = rect;
}

#pragma mark - ビュー移動関数


-(void)closeTagListMode
{
  if ([self hasActivatedTagListMode]) {
    CGRect rect = self.tagNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width + 100;
    self.tagNavigationController.view.frame = rect;
  }

}
-(void)openTagListMode
{
  if ( ! [self hasActivatedTagListMode]) {
    CGRect rect = self.tagNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width * kMarginRateForTagList;
    self.tagNavigationController.view.frame = rect;
  }
}
/**
 * @brief  タグリストを表示・非表示させる
 */
-(void)toggleTagListMode
{
  if ([self hasActivatedTagListMode]) {
    [self closeTagListMode];
  } else {
    [self openTagListMode];
  }
}
-(BOOL)hasActivatedTagListMode
{
  CGRect rect = self.tagNavigationController.view.frame;
  if (rect.origin.x >= SCREEN_BOUNDS.size.width) {
    return NO;
  } else {
    return YES;
  }
}
-(void)closeFilterListMode
{
  if ([self hasActivatedFilterListMode]) {
    CGRect rect = self.filterNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width + 100;
    self.filterNavigationController.view.frame = rect;
  }
}
-(void)openFilterListMode
{
  if ( ! [self hasActivatedFilterListMode]) {
    CGRect rect = self.filterNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width * kMarginRateForFilterList;
    self.filterNavigationController.view.frame = rect;
  }
}
/**
 * @brief  フィルターリストを表示・非表示させる
 */
-(void)toggleFilterListMode
{
  if ([self hasActivatedFilterListMode]) {
    [self closeFilterListMode];
  } else {
    [self openFilterListMode];
  }
}
-(BOOL)hasActivatedFilterListMode
{
  CGRect rect = self.filterNavigationController.view.frame;
  if (rect.origin.x >= SCREEN_BOUNDS.size.width) {
    return NO;
  } else {
    return YES;
  }
}

#pragma mark - リスト表示モード関数

-(void)toItemListMode
{
  LOG(@"アイテムリストモード");
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  [self closeTagListMode];
  [self closeFilterListMode];
  [UIView commitAnimations];
}
-(void)toTagListMode
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  [self openTagListMode];
  [self closeFilterListMode];
  [UIView commitAnimations];
}
-(void)toFilterListMode
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  [self openTagListMode];
  [self openFilterListMode];
  [UIView commitAnimations];
}
-(void)toCompleteListMode
{
}



#pragma mark - デリゲート用
/**
 *  @brief タブが選択された時の処理
 *
 *  @param tabBar タブバー
 *  @param item   選択されたタブ
 */
-(void)tabBar:(UITabBar *)tabBar
didSelectItem:(UITabBarItem *)item
{
  switch (item.tag) {
    case 0:
      LOG(@"タブ０");
      [self toItemListMode];
      break;
    case 1:
      LOG(@"タブ１");
      [self toTagListMode];
      break;
    case 2:
      LOG(@"タブ２");
      [self toFilterListMode];
      break;
    case 3:
      LOG(@"タブ３");
      [self toCompleteListMode];
      break;
    default:
      break;
  }
}
/**
 * @brief タグが選択された時の処理
 *
 * @param tagString 選択されたタグの文字列
 */
-(void)didSelectedTag:(Tag *)tag
{
  NSFetchedResultsController *result_controller;
  NSString *titleForItemList;
//  LOG(@"%@", tag.section);
//  if ([tag.section isEqualToNumber:[NSNumber numberWithInt:0]]) {
  if(tag) {
    // 指定されたタグでアイテムビューをロード
    result_controller = [CoreDataController itemFetchedResultsControllerForTags:[NSSet setWithObject:tag]
                                                                     controller:self.itemViewController];
    titleForItemList = tag.title;
    [self loadItemViewForTitle:titleForItemList
                        tags:[NSSet setWithObject:tag]
      fetcheResultController:result_controller];
  } else {
    // 全アイテムを表示
    result_controller = [CoreDataController itemFethcedResultsController:self.itemViewController];
    titleForItemList = @"all item";
    [self loadItemViewForTitle:titleForItemList
                          tags:nil
        fetcheResultController:result_controller];
  }

}

/**
 * @brief  フィルターが選択された時の処理
 *
 * @param filterTitle フィルターのタイトル
 * @param tags        フィルターのタグ
 */
-(void)didSelectedFilter:(NSString *)filterTitle
                    tags:(NSSet *)tags
{
  LOG(@"フィルターが選択された時の処理");
  NSFetchedResultsController *resultController = [CoreDataController itemFetchedResultsControllerForTags:tags
                                                                                             controller:self.itemViewController];
  [self loadItemViewForTitle:filterTitle
                        tags:tags
      fetcheResultController:resultController];
}

/**
 *  @brief メニューでタグが選択された時の処理
 *
 *  @param tag                     選択されたタグ
 *  @param fetchedResultController リザルトコントローラー
 */
- (void)loadItemViewForTitle:(NSString *)title
                       tags:(NSSet *)tags
      fetcheResultController:(NSFetchedResultsController *)fetchedResultController
{
  LOG(@"アイテムビューをロードする");
  // 選択されたタグを渡して
  self.itemViewController.tagsForSelected = tags;
  self.itemViewController.titleForList = title;
  self.itemViewController.title = title;
  self.itemViewController.fetchedResultsController = fetchedResultController;
  // テーブルを更新
  [self.itemViewController updateTableView];

  // タブバーのモードを変更する
  [self.tabBar setItemMode];
  [self toItemListMode];
}

#pragma mark - その他

/**
 * @brief メモリー警告
 */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
