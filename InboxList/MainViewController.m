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
#import "FilterDetailViewController.h"
#import "CoreDataController.h"
#import "Configure.h"
#import "ListViewController.h"

#define kDurationForListModeSegue 0.2f

#define kMarginRateForTagList 0
#define kMarginRateForFilterList 0

#define kDurationForHiddenTabBar 0.2f

#pragma mark -

@interface MainViewController () {

}

@property ListViewController *mainViewController_;
@property UIViewAnimationCurve animationCurve_;

@end


@implementation MainViewController

#pragma mark - 初期化

/**
*  @brief  パラメータを初期化
*/
- (void)initParameter
{
  swipe_distance = SWIPE_DURATION;
  self.animationCurve_ = UIViewAnimationCurveEaseInOut;
}

/**
 *  @brief  ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // パラメータを初期化する
  [self initParameter];

  // タブバーを初期化する
  self.tabBar = [[TabBar alloc] initWithFrame:CGRectMake(0,
                                                         SCREEN_BOUNDS.size.height-TABBAR_H,
                                                         SCREEN_BOUNDS.size.width,
                                                         TABBAR_H)];
  self.tabBar.delegate = self;

  //////////////////////////////////////////////////////////////////////////////
  // アイテムリストを初期化・設定する
  self.itemViewController = [[ItemViewController alloc] initWithNibName:nil
                                                                 bundle:nil];

  self.itemViewController.fetchedResultsController = [CoreDataController itemFethcedResultsController:self.itemViewController];
  [self.itemViewController configureTitleWithString:@"ITEM"
                                           subTitle:@"Inbox"
                                           subColor:ITEM_COLOR];
  
  self.itemNavigationController = [[ItemNavigationController alloc] initWithRootViewController:self.itemViewController];
  self.itemViewController.navigationController = self.itemNavigationController;
  
  CALayer *itemLayer = self.itemNavigationController.view.layer;
  itemLayer.shadowOpacity = 0.8f;

  //////////////////////////////////////////////////////////////////////////////
  // タグビューコントローラを初期化
  self.tagViewController = [[TagViewController alloc] initWithNibName:nil
                                                               bundle:nil];
  self.tagViewController.delegate = self;
  self.tagViewController.fetchedResultsController = [CoreDataController tagFetchedResultsController:self.tagViewController];
  self.tagNavigationController = [[TagNavigationController alloc] initWithRootViewController:self.tagViewController];
  self.tagViewController.navigationController = self.tagNavigationController;
  
  //////////////////////////////////////////////////////////////////////////////
  // フィルターコントローラを初期化
  self.filterViewController = [[FilterViewController alloc] initWithNibName:nil
                                                                     bundle:nil];
  self.filterViewController.delegate = self;
  self.filterViewController.fetchedResultsController = [CoreDataController filterFetchedResultsController:self.filterViewController];
  self.filterNavigationController = [[FilterNavigationController alloc] initWithRootViewController:self.filterViewController];

  //////////////////////////////////////////////////////////////////////////////
  // 完了リストコントローラーを初期化
  self.completeViewController = [[CompleteViewController alloc] initWithNibName:nil
                                                                         bundle:nil];
  self.completeViewController.fetchedResultsController = [CoreDataController completeFetchedResultsController:self.completeViewController];
  [self.completeViewController configureTitleWithString:@"COMPLETE"
                                               subTitle:@"0 items are completed."
                                               subColor:GRAY_COLOR];
  self.completeNavigationController
  = [[CompleteNavigationController alloc] initWithRootViewController:self.completeViewController];
  
  // コントローラーを配置する
  // タグリストを最下にする
  [self.view addSubview:self.tagNavigationController.view];
  [self.view addSubview:self.filterNavigationController.view];
  [self.view addSubview:self.itemNavigationController.view];
  [self.view addSubview:self.completeNavigationController.view];
  [self.view addSubview:self.tabBar];
  
  // アイテムリストモードで開始
  [self toItemListModeWithDuration:0.0f];
  
  // デリゲートを設定
  self.itemViewController.delegateForList = self;
  self.tagViewController.delegateForList = self;
  self.filterViewController.delegateForList = self;
  self.completeViewController.delegateForList = self;
}

#pragma mark - ビュー移動関数
#pragma mark - アイテムリスト
/**
 * @brief  アイテムリストを開閉する
 *
 * @param open 開閉
 */
-(void)toggleItemList:(BOOL)open margin:(CGFloat)rightMarginRate
{
  if (open) {
    // 開く
    CGRect rect = self.itemNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width * kMarginRateForTagList;
    self.itemNavigationController.view.frame = rect;
  } else {
    // 閉じる
    CGRect rect = self.itemNavigationController.view.frame;
    rect.origin.x = - SCREEN_BOUNDS.size.width + rightMarginRate;
    self.itemNavigationController.view.frame = rect;
  }
}

#pragma mark タグリスト

/**
 * @brief  タグリストを表示・非表示させる
 */
-(void)closeTagListMode
{
  // TODO: コメントなど
  if ([self hasActivatedTagListMode]) {
    CGRect rect = self.tagNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width + 100;
    self.tagNavigationController.view.frame = rect;
  }
}

/**
 * @brief  タグリストを開く
 */
-(void)openTagListMode
{
  if ( ! [self hasActivatedTagListMode]) {
    CGRect rect = self.tagNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width * kMarginRateForTagList;
    self.tagNavigationController.view.frame = rect;
  }
}

/**
 * @brief  タグリストがアクティブか評価する
 *
 * @return 真偽値
 */
-(BOOL)hasActivatedTagListMode
{
  CGRect rect = self.tagNavigationController.view.frame;
  if (rect.origin.x >= SCREEN_BOUNDS.size.width) {
    return NO;
  } else {
    return YES;
  }
}

#pragma mark フィルターリスト

/**
 * @brief  フィルターリストを表示・非表示させる
 */
-(void)closeFilterListMode
{
  if ([self hasActivatedFilterListMode]) {
    CGRect rect = self.filterNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width;
    self.filterNavigationController.view.frame = rect;
  }
}

/**
 * @brief  フィルターリストにする
 */
-(void)openFilterListMode
{
  if ( ! [self hasActivatedFilterListMode]) {
    CGRect rect = self.filterNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width * kMarginRateForFilterList + ITEM_LIST_REMAIN_MARGIN;
    self.filterNavigationController.view.frame = rect;
  }
}

-(void)toggleFilterListMode
{
  if ([self hasActivatedFilterListMode]) {
    // フィルターモードを閉じる
    [self closeFilterListMode];
  } else {
    // フィルターリストにする
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

#pragma mark 完了リスト
/**
 * @brief  完了リストを表示・非表示させる
 */
-(void)closeCompleteListMode
{
  if ([self hasActivatedCompleteListMode]) {
    CGRect rect = self.completeNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width + 100;
    self.completeNavigationController.view.frame = rect;
  }
}
-(void)openCompleteListMode
{
  if ( ! [self hasActivatedCompleteListMode]) {
    CGRect rect = self.completeNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width * kMarginRateForFilterList;
    self.completeNavigationController.view.frame = rect;
  }
}

-(void)toggleCompleteListMode
{
  if ([self hasActivatedCompleteListMode]) {
    [self closeCompleteListMode];
  } else {
    [self openCompleteListMode];
  }
}
-(BOOL)hasActivatedCompleteListMode
{
  CGRect rect = self.completeNavigationController.view.frame;
  if (rect.origin.x >= SCREEN_BOUNDS.size.width) {
    return NO;
  } else {
    return YES;
  }
}
#pragma mark - タブバー
-(BOOL)hasTabBar
{
  CGFloat y = self.tabBar.frame.origin.y;
  if (y < SCREEN_BOUNDS.size.height) {
    return YES;
  } else {
    return NO;
  }
}

-(void)openTabBar
{
  if ( ! [self hasTabBar]) {
    CGRect rect = CGRectMake(0,
                             SCREEN_BOUNDS.size.height-TABBAR_H,
                             SCREEN_BOUNDS.size.width,
                             TABBAR_H);
    [UIView animateWithDuration:kDurationForHiddenTabBar
                     animations:^{
                       self.tabBar.frame = rect;
                     }];
  }
}

-(void)closeTabBar
{
  if ([self hasTabBar]) {
    CGRect rect = CGRectMake(0,
                             SCREEN_BOUNDS.size.height,
                             SCREEN_BOUNDS.size.width,
                             TABBAR_H);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kDurationForHiddenTabBar];
    if (self.mainViewController_ == self.tagViewController || self.mainViewController_ == self.filterViewController) {
      // タグリストの時は遅らせる
      [UIView setAnimationDelay:0.2f];
    }
    
    self.tabBar.frame = rect;
    
    [UIView commitAnimations];
    
  }
}

#pragma mark - ユーティリティ

/**
 * @brief  トップがアイテムリストなら真
 *
 * @return 真偽値
 */
-(BOOL)isItemListInMain
{
  if (self.mainViewController_ == self.itemViewController) {
    return YES;
  }
  return NO;
}
/**
 * @brief  トップがタグリストなら真
 *
 * @return 真偽値
 */
-(BOOL)isTagListInMain
{
  if (self.mainViewController_ == self.tagViewController) {
    return YES;
  }
  return NO;
}
/**
 * @brief  トップがフィルターリストなら真
 *
 * @return 真偽値
 */
-(BOOL)isFilterListInMain
{
  if (self.mainViewController_ == self.filterViewController) {
    return YES;
  }
  return NO;
}
/**
 * @brief  トップが完了リストなら真
 *
 * @return 真偽値
 */
-(BOOL)isCompleteListInMain
{
  if (self.mainViewController_ == self.completeViewController) {
    return YES;
  }
  return NO;
}

-(BOOL)isTopViewController:(ListViewController *)viewController
{
  if (viewController == self.mainViewController_) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - リスト表示モード関数

-(void)listWillEditMode
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.3f];

  // アイテムリスト
  CGRect rect = self.itemNavigationController.view.frame;
  rect.origin.x = - SCREEN_BOUNDS.size.width - 10;
  self.itemNavigationController.view.frame = rect;
  
  // ナビゲーションコントローラー
  ListViewController *controller;
  __NavigationController *navicontroller;
  if (self.mainViewController_ == self.tagViewController) {
    controller = self.tagViewController;
    navicontroller = self.tagNavigationController;
  } else {
    controller = self.filterViewController;
    navicontroller = self.filterNavigationController;
  }
  
  CGRect frame = navicontroller.view.frame;
  frame.size.width = SCREEN_BOUNDS.size.width;
  frame.origin.x = 0;
  navicontroller.view.frame = frame;

  // テーブル
  CGRect tframe = controller.tableView.frame;
  tframe.size.width = SCREEN_BOUNDS.size.width;
  controller.tableView.frame = tframe;
  
  [UIView commitAnimations];
}
-(void)listDidEditMode
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.3f];

  // アイテムリスト
  CGRect rect = self.itemNavigationController.view.frame;
  rect.origin.x = - SCREEN_BOUNDS.size.width + ITEM_LIST_REMAIN_MARGIN;
  self.itemNavigationController.view.frame = rect;
  
  // ナビゲーションコントローラー
  ListViewController *controller;
  __NavigationController *navicontroller;
  if (self.mainViewController_ == self.tagViewController) {
    controller = self.tagViewController;
    navicontroller = self.tagNavigationController;
  } else {
    controller = self.filterViewController;
    navicontroller = self.filterNavigationController;
  }
  CGRect frame = navicontroller.view.frame;
  frame.size.width = SCREEN_BOUNDS.size.width - ITEM_LIST_REMAIN_MARGIN;
  frame.origin.x = ITEM_LIST_REMAIN_MARGIN;
  navicontroller.view.frame = frame;
  
  // テーブル
  CGRect tframe = controller.tableView.frame;
  tframe.size.width = SCREEN_BOUNDS.size.width - ITEM_LIST_REMAIN_MARGIN;
  controller.tableView.frame = tframe;
  
  [UIView commitAnimations];
}

-(void)listDidEditModeWithDelay:(CGFloat)delay
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.3f];
  [UIView setAnimationDelay:delay];
  
  // アイテムリスト
  CGRect rect = self.itemNavigationController.view.frame;
  rect.origin.x = - SCREEN_BOUNDS.size.width + ITEM_LIST_REMAIN_MARGIN;
  self.itemNavigationController.view.frame = rect;
  
  // ナビゲーションコントローラー
  ListViewController *controller;
  __NavigationController *navicontroller;
  if (self.mainViewController_ == self.tagViewController) {
    controller = self.tagViewController;
    navicontroller = self.tagNavigationController;
  } else {
    controller = self.filterViewController;
    navicontroller = self.filterNavigationController;
  }
  CGRect frame = navicontroller.view.frame;
  frame.size.width = SCREEN_BOUNDS.size.width - ITEM_LIST_REMAIN_MARGIN;
  frame.origin.x = ITEM_LIST_REMAIN_MARGIN;
  navicontroller.view.frame = frame;
  
  // テーブル
  CGRect tframe = controller.tableView.frame;
  tframe.size.width = SCREEN_BOUNDS.size.width - ITEM_LIST_REMAIN_MARGIN;
  controller.tableView.frame = tframe;
  
  [UIView commitAnimations];
}

-(void)toggleShowVerticalScrollIndicatorWithController:(ListViewController *)controller
{
  if (controller == self.itemViewController) {
    self.itemViewController.tableView.showsVerticalScrollIndicator = YES;
  } else {
    self.itemViewController.tableView.showsVerticalScrollIndicator = NO;
  }
}

/**
 * @brief  アイテムリストのスクロールを停止する
 */
-(void)stopItemListScroll
{
  CGPoint offset = self.itemViewController.tableView.contentOffset;
  offset.y = MAX(0, offset.y);
  [self.itemViewController.tableView setContentOffset:offset
                                             animated:YES];
}

-(void)toItemListMode
{
  // 既にアイテムリストがメインなら、
  // １番上までスクロールさせて、終了する。
  if ([self isItemListInMain]) {
    [self.itemViewController scrollToTopCell];
    return;
  }
  self.itemNavigationController.view.userInteractionEnabled = YES;
  
  // スクロールバーを表示する
  [self toggleShowVerticalScrollIndicatorWithController:self.itemViewController];
  
  LOG(@"アイテムリストモード");
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:kDurationForListModeSegue];
  [UIView setAnimationCurve:self.animationCurve_];
//  [self closeTagListMode];
  [self toggleItemList:YES margin:ITEM_LIST_REMAIN_MARGIN];
  [self closeFilterListMode];
  [self closeCompleteListMode];
  [UIView commitAnimations];
  
  self.mainViewController_ = self.itemViewController;
}
-(void)toItemListModeWithDuration:(NSTimeInterval)duration
{
  // 既にアイテムリストがメインなら、
  // １番上までスクロールさせて、終了する。
  if ([self isItemListInMain]) {
    [self.itemViewController scrollToTopCell];
    return;
  }
  
  self.itemNavigationController.view.userInteractionEnabled = YES;
  
  // スクロールバーを表示する
  [self toggleShowVerticalScrollIndicatorWithController:self.itemViewController];
  
  LOG(@"アイテムリストモード");
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationCurve:self.animationCurve_];
//  [self closeTagListMode];
  [self toggleItemList:YES margin:ITEM_LIST_REMAIN_MARGIN];
  [self closeFilterListMode];
  [self closeCompleteListMode];
  [UIView commitAnimations];
  
  self.mainViewController_ = self.itemViewController;
}
-(void)toTagListMode
{
  // 既にアイテムリストがメインなら、
  // １番上までスクロールさせて、終了する。
  if ([self isTagListInMain]) {
    [self.tagViewController scrollToTopCell];
    return;
  }
  
  self.itemNavigationController.view.userInteractionEnabled = NO;

  // スクロールバーを非表示する
  [self toggleShowVerticalScrollIndicatorWithController:self.tagViewController];
  // スクロールを止める
  [self stopItemListScroll];
  
  
  LOG(@"タグリストモード");
  [self.tagViewController updateTableView];
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:kDurationForListModeSegue];
  [UIView setAnimationCurve:self.animationCurve_];
  [self openTagListMode];
  [self toggleItemList:NO margin:ITEM_LIST_REMAIN_MARGIN];
  [self closeFilterListMode];
  [self closeCompleteListMode];
  [UIView commitAnimations];
  
  self.mainViewController_ = self.tagViewController;
}
-(void)toFilterListMode
{
  // 既にアイテムリストがメインなら、
  // １番上までスクロールさせて、終了する。
  if ([self isFilterListInMain]) {
    [self.filterViewController scrollToTopCell];
    return;
  }
  self.itemNavigationController.view.userInteractionEnabled = NO;
  
  // スクロールバーを非表示にする
  [self toggleShowVerticalScrollIndicatorWithController:self.filterViewController];
  // スクロールを止める
  [self stopItemListScroll];
  
  LOG(@"フィルターリストモード");
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:kDurationForListModeSegue];
  [UIView setAnimationCurve:self.animationCurve_];
  [self openTagListMode];
  [self toggleItemList:NO margin:ITEM_LIST_REMAIN_MARGIN];
  [self openFilterListMode];
  [self closeCompleteListMode];
  [UIView commitAnimations];
  
  self.mainViewController_ = self.filterViewController;
}
-(void)toCompleteListMode
{
  // 既にアイテムリストがメインなら、
  // １番上までスクロールさせて、終了する。
  if ([self isCompleteListInMain]) {
    [self.completeViewController scrollToTopCell];
    return;
  }
  self.itemNavigationController.view.userInteractionEnabled = NO;

  // スクロールバーを非表示にする
  [self toggleShowVerticalScrollIndicatorWithController:self.completeViewController];
  // スクロールを止める
  [self stopItemListScroll];
  
  LOG(@"完了リストモード");
  [self.completeViewController updateTableView];
  
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:kDurationForListModeSegue];
  [UIView setAnimationCurve:self.animationCurve_];
  [self openTagListMode];
  [self toggleItemList:NO margin:ITEM_LIST_REMAIN_MARGIN];
  [self openFilterListMode];
  [self openCompleteListMode];
  [UIView commitAnimations];
  
  self.mainViewController_ = self.completeViewController;
}

#pragma mark - デリゲート用
#pragma mark タブバー
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

#pragma mark タグリスト
/**
 * @brief タグが選択された時の処理
 *
 * @param tagString 選択されたタグの文字列
 */
-(void)didSelectTag:(Tag *)tag
{
  NSFetchedResultsController *result_controller;
  NSString *titleForItemList;

  if(tag) {
    // 指定されたタグでアイテムビューをロード
    result_controller = [CoreDataController itemFetchedResultsControllerForTags:[NSSet setWithObject:tag]
                                                                     controller:self.itemViewController];
    titleForItemList = tag.title;
    [self loadItemViewForTitle:titleForItemList
                      subColor:TAG_COLOR
                        tags:[NSSet setWithObject:tag]
      fetcheResultController:result_controller];
  } else {
    // 全アイテムを表示
    // @note サブタイトル色は黒色
    result_controller = [CoreDataController itemFethcedResultsController:self.itemViewController];
    titleForItemList = @"Inbox";
    [self loadItemViewForTitle:titleForItemList
                      subColor:ITEM_COLOR
                          tags:nil
        fetcheResultController:result_controller];
  }

}

#pragma mark フィルターリスト
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
                    subColor:FILTER_COLOR
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
                    subColor:(UIColor *)subColor
                       tags:(NSSet *)tags
      fetcheResultController:(NSFetchedResultsController *)fetchedResultController
{
  LOG(@"アイテムビューをロードする");
  // 選択されたタグを渡して
  if (tags) {
    self.itemViewController.selectedTags = tags;
    [self.itemViewController hideSectionHeader];
  } else {
    self.itemViewController.selectedTags = nil;
    [self.itemViewController showSectionHeader];
  }
  self.itemViewController.fetchedResultsController = fetchedResultController;
  // テーブルを更新
  [self.itemViewController updateTableView];
  
  LOG(@"ナビゲーションバーのタイトルを更新");
  [self.itemViewController configureTitleWithString:@"ITEM"
                                           subTitle:title
                                           subColor:subColor];

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
