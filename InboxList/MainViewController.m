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

#define kDurationForHiddenTabBar 0.2

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
  
  LOG(@"パラメータ初期化");
  [self initParameter];

  LOG(@"タブバー初期化");
  self.tabBar = [[TabBar alloc] initWithFrame:CGRectMake(0,
                                                         SCREEN_BOUNDS.size.height-TABBAR_H,
                                                         SCREEN_BOUNDS.size.width,
                                                         TABBAR_H)];
  self.tabBar.delegate = self;

  // アイテムリストを初期化・設定
  LOG(@"アイテムリストを初期化・設定");
  self.itemViewController = [[ItemViewController alloc] initWithNibName:nil
                                                                 bundle:nil];

  self.itemViewController.fetchedResultsController = [CoreDataController itemFethcedResultsController:self.itemViewController];
  [self.itemViewController configureTitleWithString:@"ITEMS"
                                           subTitle:@"All Items"];
  
  self.itemNavigationController = [[ItemNavigationController alloc] initWithRootViewController:self.itemViewController];


  // フィルターコントローラを初期化
  self.filterViewController = [[FilterViewController alloc] initWithNibName:nil
                                                                     bundle:nil];
  self.filterViewController.delegate = self;
  self.filterViewController.fetchedResultsController = [CoreDataController filterFetchedResultsController:self.filterViewController];
  self.filterNavigationController = [[FilterNavigationController alloc] initWithRootViewController:self.filterViewController];
  
  // タグビューコントローラを初期化
  self.tagViewController = [[TagViewController alloc] initWithNibName:nil
                                                               bundle:nil];
  self.tagViewController.delegate = self;
  self.tagViewController.fetchedResultsController = [CoreDataController tagFetchedResultsController:self.tagViewController];
  self.tagNavigationController = [[TagNavigationController alloc] initWithRootViewController:self.tagViewController];
  
  // 完了リストコントローラーを初期化
  LOG(@"完了リストコントローラーを初期化・設定");
  self.completeViewController = [[CompleteViewController alloc] initWithNibName:nil
                                                                         bundle:nil];
  self.completeNavigationController
  = [[__NavigationController alloc] initWithRootViewController:self.completeViewController];
  
  // コントローラーを配置
  LOG(@"コントローラーを配置");
  [self.view addSubview:self.itemNavigationController.view];
  [self.view addSubview:self.tagNavigationController.view];
  [self.view addSubview:self.filterNavigationController.view];
  [self.view addSubview:self.completeNavigationController.view];
  [self.view addSubview:self.tabBar];
  
  // アイテムリストモードで開始
  [self toItemListModeWithDuration:0.0f];
  
  // デリゲートを設定
  self.itemViewController.delegateForList = self;
  self.tagViewController.delegateForList = self;
  self.filterViewController.delegateForList = self;
  self.completeViewController.delegateForList = self;
  
  // リストのサイズを変更
//  CGRect rect =  self.filterNavigationController.view.frame;
//  rect.size.width = SCREEN_BOUNDS.size.width * ( 1.0 - kMarginRateForTagList );
//  self.tagNavigationController.view.frame = rect;
//  rect =  self.filterNavigationController.view.frame;
//  rect.size.width = SCREEN_BOUNDS.size.width * ( 1.0 - kMarginRateForFilterList );
//  self.filterNavigationController.view.frame = rect;
}

#pragma mark - ビュー移動関数

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
-(void)openTagListMode
{
  if ( ! [self hasActivatedTagListMode]) {
    CGRect rect = self.tagNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width * kMarginRateForTagList;
    self.tagNavigationController.view.frame = rect;
  }
}

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

#pragma mark フィルターリスト
/**
 * @brief  フィルターリストを表示・非表示させる
 */
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

#pragma mark 完了リスト
/**
 * @brief  完了リストを表示・非表示させる
 */
-(void)closeCompleteListMode
{
  LOG(@"完了リストを閉じる");
  if ([self hasActivatedCompleteListMode]) {
    CGRect rect = self.completeNavigationController.view.frame;
    rect.origin.x = SCREEN_BOUNDS.size.width + 100;
    self.completeNavigationController.view.frame = rect;
  }
}
-(void)openCompleteListMode
{
  LOG(@"完了リストを開く");
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
    [UIView animateWithDuration:kDurationForHiddenTabBar
                     animations:^{
                       self.tabBar.frame = rect;
                     }];
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
  [self closeCompleteListMode];
  [UIView commitAnimations];
}
-(void)toItemListModeWithDuration:(NSTimeInterval)duration
{
  LOG(@"アイテムリストモード");
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:duration];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  [self closeTagListMode];
  [self closeFilterListMode];
  [self closeCompleteListMode];
  [UIView commitAnimations];
}
-(void)toTagListMode
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  [self openTagListMode];
  [self closeFilterListMode];
  [self closeCompleteListMode];
  [UIView commitAnimations];
}
-(void)toFilterListMode
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  [self openTagListMode];
  [self openFilterListMode];
  [self closeCompleteListMode];
  [UIView commitAnimations];
}
-(void)toCompleteListMode
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.2];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
  [self openTagListMode];
  [self openFilterListMode];
  [self openCompleteListMode];
  [UIView commitAnimations];
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
                        tags:[NSSet setWithObject:tag]
      fetcheResultController:result_controller];
  } else {
    // 全アイテムを表示
    result_controller = [CoreDataController itemFethcedResultsController:self.itemViewController];
    titleForItemList = @"all items";
    [self loadItemViewForTitle:titleForItemList
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
  if (tags) {
    for (Tag *tag in tags) {
      // １個だけ渡す
      self.itemViewController.tagForSelected = tag;
      break;
    }
    [self.itemViewController hideSectionHeader];
  } else {
    self.itemViewController.tagForSelected = nil;
    [self. itemViewController showSectionHeader];
  }
  self.itemViewController.fetchedResultsController = fetchedResultController;
  // テーブルを更新
  [self.itemViewController updateTableView];
  
  LOG(@"ナビゲーションバーのタイトルを更新");
  [self.itemViewController configureTitleWithString:@"ITEM"
                                           subTitle:title];

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
