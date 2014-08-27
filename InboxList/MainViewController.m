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
#import "ResultControllerFactory.h"
#import "CoreDataController.h"
#import "Configure.h"

/**
 リストモード
 */
enum __LIST_MODE__ {
  __ITEM_MODE__,
  __TAG_MODE__,
  __FILTER_MODE__,
  __COMPLETE_MODE__
};


@interface MainViewController () {
  enum __LIST_MODE__ currentListMode_;
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
  [self initParameter];

  LOG(@"タブバー初期化");
  self.tabBar = [[TabBar alloc] initWithFrame:CGRectMake(0,
                                                         SCREEN_BOUNDS.size.height-TABBAR_H,
                                                         SCREEN_BOUNDS.size.width,
                                                         TABBAR_H)];
  self.tabBar.delegate = self;
  
  LOG(@"アイテムビューを初期化");
  self.itemViewController = [[ItemViewController alloc] initWithStyle:UITableViewStylePlain];
  self.itemViewController.fetchedResultsController = [ResultControllerFactory fetchedResultsController:self.itemViewController]; // はじめは全アイテムを表示
    
  LOG(@"ナビゲーションコントローラー初期化");
  
  self.itemNavigationController = [[ItemNavigationController alloc] initWithRootViewController:self.itemViewController];
 
  LOG(@"フィルターコントローラーを初期化");
  self.filterViewController = [[FilterViewController alloc] initWithNibName:nil bundle:nil];
  self.filterViewController.delegate = self;
  self.filterViewController.fetchedResultsController = [CoreDataController filterFetchedResultsController:self.filterViewController];
  self.filterNavigationController = [[FilterNavigationController alloc] initWithRootViewController:self.filterViewController];
  
  
  LOG(@"タグモード初期化");
  self.tagViewController = [[TagViewController alloc] initWithNibName:nil
                                                               bundle:nil];
  self.tagViewController.delegate = self;
  self.tagViewController.fetchedResultsController = [CoreDataController tagFetchedResultsController:self.tagViewController];
  self.tagNavigationController = [[TagNavigationController alloc] initWithRootViewController:self.tagViewController];
  
  LOG(@"コントローラーを配置");
  [self.view addSubview:self.tagNavigationController.view];
  [self.view addSubview:self.filterNavigationController.view];
  [self.view addSubview:self.itemNavigationController.view];
  [self.view addSubview:self.tabBar];
  
  LOG(@"アイテムモードにする");
  currentListMode_ = __ITEM_MODE__;
}

/**
 * @brief  指定のモードをトップに表示する
 *
 * @param controller コントローラー
 */
-(void)bringTopMode:(UIViewController *)controller
{
  NSMutableArray *modearray = [NSMutableArray arrayWithObjects:
                               self.itemNavigationController,
                               self.tagNavigationController,
                               self.filterNavigationController,
                               nil];
  UIView *currentview;
  switch (currentListMode_) {
    case __ITEM_MODE__:
      [modearray removeObject:self.itemNavigationController];
      currentview = self.itemNavigationController.view;
      break;
    case __TAG_MODE__:
      [modearray removeObject:self.tagNavigationController];
      currentview = self.tagNavigationController.view;
      break;
    case __FILTER_MODE__:
      [modearray removeObject:self.filterNavigationController];
      currentview = self.filterNavigationController.view;
      break;
    case __COMPLETE_MODE__:
//      [modearray removeObject:self.itemNavigationController];
//      break;
      return;
    default:
      break;
  }
  [modearray removeObject:controller];
  
  [self.view sendSubviewToBack:currentview];
  for (UIViewController *mode in modearray) {
    [self.view sendSubviewToBack:mode.view];
  }
}

#pragma mark - リスト変更関数

-(void)setItemMode
{
  currentListMode_ = __ITEM_MODE__;
  [self.tabBar setItemMode];
}
-(BOOL)isItemMode
{
  if (currentListMode_ == __ITEM_MODE__) {
    return YES;
  } else return NO;
}
-(void)setTagMode
{
  currentListMode_ = __TAG_MODE__;
  [self.tabBar setTagMode];
}
-(void)setFilterMode
{
  currentListMode_ = __FILTER_MODE__;
  [self.tabBar setFilterMode];
}
-(void)setCompleteMode
{
  currentListMode_ = __COMPLETE_MODE__;
  [self.tabBar setCompletedMode];
}

#pragma mark - リスト表示モード関数

/**
 *  アイテムリスト表示モード
 */
-(void)toItemListMode
{
  [self bringTopMode:self.itemNavigationController]; // アイテムビューをトップにする

  LOG(@"アイテムリストモード");
  switch (currentListMode_) {
    case __ITEM_MODE__:
      LOG(@"何もしない");
      return;
      break;
      
    case __TAG_MODE__:
      break;
      
    case __FILTER_MODE__:
      break;
      
    case __COMPLETE_MODE__:
      break;
      
    default:
      break;
  }
  
  [self setItemMode];
  CGPoint next_center = self.itemNavigationController.view.center;

  CGFloat screen_center_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x

  next_center.x = screen_center_x;

  [UIView animateWithDuration:SWIPE_DURATION
                   animations:^{
                     self.itemNavigationController.view.center = next_center;
                   }];
}

/**
 *  タグリスト表示モード
 */
-(void)toTagListMode
{
  [self bringTopMode:self.tagNavigationController]; // アイテムビューをトップにする
  
  [self setTagMode];
  switch (currentListMode_) {
    case __ITEM_MODE__:
      break;
      
    case __TAG_MODE__:
      LOG(@"何もしない");
      return;
      break;
      
    case __FILTER_MODE__:
      break;
      
    case __COMPLETE_MODE__:
      break;
      
    default:
      break;
  }

  
  LOG(@"タグリストモード");
//  int distance = SCREEN_BOUNDS.size.width;
  CGPoint next_center = self.itemNavigationController.view.center;
  CGFloat screen_center_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x

  self.tagViewController.tagArray_ = [CoreDataController getAllTagsArray];
  [self.tagViewController updateTableView]; //< ビューを更新

  next_center.x = screen_center_x + swipe_distance;
//  [self.view sendSubviewToBack:self.filterNavigationController.view];
  
  [UIView animateWithDuration:SWIPE_DURATION
                   animations:^{
                     self.itemNavigationController.view.center = next_center;
                   }];
}
/**
 *  フィルターリスト表示モード
 */
-(void)toFilterListMode
{
  [self bringTopMode:self.filterNavigationController]; // アイテムビューをトップにする

  switch (currentListMode_) {
    case __ITEM_MODE__:
      break;
    case __TAG_MODE__:
      break;
    case __FILTER_MODE__:
      LOG(@"何もしない");
      return;
      break;
    case __COMPLETE_MODE__:
      break;
    default:
      break;
  }
  [self setFilterMode];
  
  LOG(@"フィルターリストモード");
  CGPoint next_center = self.filterNavigationController.view.center;
  CGFloat screen_center_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x

  next_center.x = screen_center_x - swipe_distance;

  [UIView animateWithDuration:SWIPE_DURATION
                   animations:^{
                     self.itemNavigationController.view.center = next_center;
                   }];
}

-(void)toCompleteListMode
{
  LOG(@"コンプリートリストモード");
  [self setCompleteMode];
  return;
}

/**
 *  タブが選択された時の処理
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

#pragma mark - デリゲート用

/**
 *  タグが選択された時の処理
 *
 *  @param tagString 選択されたタグの文字列
 */
-(void)selectedTag:(NSString *)tagString
{
  LOG(@"タグが選択された時の処理");
  if ([tagString isEqualToString:@""]) {
    [self loadItemViewForTag:@"NO TAGS"
        fetcheResultController:[ResultControllerFactory fetchedResultsController:self.itemViewController]];
    return;
  }

  LOG(@"指定されたタグでロード");
  [self loadItemViewForTag:tagString
      fetcheResultController:[ResultControllerFactory fetchedResultsControllerForTags:[NSSet setWithObject:tagString]
                                                                             delegate:self.itemViewController]];
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
  [self loadItemViewForTag:filterTitle
      fetcheResultController:resultController];
}

/**
 * メニューでタグが選択された時の処理
 */
/**
 *  メニューでタグが選択された時の処理
 *
 *  @param tag                     選択されたタグ
 *  @param fetchedResultController リザルトコントローラー
 */
- (void)loadItemViewForTag:(NSString *)tag
      fetcheResultController:(NSFetchedResultsController *)fetchedResultController
{
  LOG(@"アイテムビューをロードする");
  self.itemViewController.selectedTagString = tag;// 選択されたタグを渡して
  self.itemViewController.fetchedResultsController = fetchedResultController;
  [self.itemViewController updateTableView]; // テーブルを更新
  [self.itemViewController setTitle:tag]; // タグの名前に変える

  [self.tabBar setItemMode];
  [self toItemListMode];
}

#pragma mark - その他

/**
 * メモリー警告
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
