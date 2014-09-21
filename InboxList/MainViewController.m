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

/**
 リストモード
 */
enum __LIST_MODE__ {
  __ITEM_MODE__,    ///< アイテムモード
  __TAG_MODE__,     ///< タグモード
  __FILTER_MODE__,  ///< フィルターモード
  __COMPLETE_MODE__ ///< コンプリートモード
};

@interface MainViewController ()
{
  enum __LIST_MODE__ currentListMode_;
}

-(void)setLeft:(UIView *)view;
-(void)setCenter:(UIView *)view;
-(void)setRight:(UIView *)view;

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
  self.itemViewController = [[ItemViewController alloc] initWithStyle:UITableViewStylePlain];

  self.itemViewController.fetchedResultsController = [CoreDataController itemFethcedResultsController:self.itemViewController];
    
  // ナビゲーションコントローラを初期化
  
  self.itemNavigationController = [[ItemNavigationController alloc] initWithRootViewController:self.itemViewController];
 

  // フィルターコントローラを初期化
  self.filterViewController = [[FilterViewController alloc] initWithNibName:nil bundle:nil];
  self.filterViewController.delegate = self;
  self.filterViewController.fetchedResultsController = [CoreDataController filterFetchedResultsController:self.filterViewController];
  self.filterNavigationController = [[FilterNavigationController alloc] initWithRootViewController:self.filterViewController];
  
  // タグビューコントローラを初期化
  self.tagViewController = [[TagViewController alloc] initWithNibName:nil
                                                               bundle:nil];
  self.tagViewController.delegate = self;
  self.tagViewController.fetchedResultsController = [CoreDataController tagFetchedResultsController:self.tagViewController];
  self.tagNavigationController = [[TagNavigationController alloc] initWithRootViewController:self.tagViewController];
  
  // コントローラーを配置
  [self.view addSubview:self.tagNavigationController.view];
  [self.view addSubview:self.filterNavigationController.view];
  [self.view addSubview:self.itemNavigationController.view];
  [self.view addSubview:self.tabBar];
  
  // アイテムモードにする
  [self setItemMode];
}

#pragma mark - ビュー移動関数

-(void)setLeft:(UIView *)view
{
  CGRect rect = view.frame;
  rect.origin.x = 0 - view.frame.size.width;
  view.frame = rect;
}

-(void)setCenter:(UIView *)view
{
  CGRect rect = view.frame;
  rect.origin.x = 0;
  view.frame = rect;
}

-(void)setRight:(UIView *)view
{
  CGRect rect = view.frame;
  rect.origin.x = view.frame.size.width;
  view.frame = rect;
}

/**
 * @brief  指定方向からアイテムリストを呼び出し
 *
 * @param direction 呼び出す方向
 */
-(void)bringItemListFrom:(enum __LIST_DIRECTION__)direction
{
  [self setItemMode];
  UIView *view = self.itemNavigationController.view;
  if (direction == __FROM_RIGHT__) {
    [self setRight:view];
  } else {
    [self setLeft:view];
  }
  [self.view bringSubviewToFront:view];
  [self.view bringSubviewToFront:self.tabBar];
  [UIView animateWithDuration:SWIPE_DURATION
                        delay:0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [self setCenter:view];
                   } completion:^(BOOL finished) {
                     ;
                   }];
//  [UIView animateWithDuration:SWIPE_DURATION
//                   animations:^{
//                     [self setCenter:view];
//                   }];
}
/**
 * @brief  指定方向からタグリストを呼び出し
 *
 * @param direction 呼び出す方向
 */
-(void)bringTagListFrom:(enum __LIST_DIRECTION__)direction
{
  [self setTagMode];
  UIView *view = self.tagNavigationController.view;
  if (direction == __FROM_RIGHT__) {
    [self setRight:view];
  } else {
    [self setLeft:view];
  }
  [self.view bringSubviewToFront:view];
  [self.view bringSubviewToFront:self.tabBar];
  [UIView animateWithDuration:SWIPE_DURATION
                   animations:^{
                     [self setCenter:view];
                   }];
}
/**
 * @brief  指定方向からフィルターリストを呼び出し
 *
 * @param direction 呼び出す方向
 */
-(void)bringFilterListFrom:(enum __LIST_DIRECTION__)direction
{
  [self setFilterMode];
  UIView *view = self.filterNavigationController.view;
  if (direction == __FROM_RIGHT__) {
    [self setRight:view];
  } else {
    [self setLeft:view];
  }
  [self.view bringSubviewToFront:view];
  [self.view bringSubviewToFront:self.tabBar];
  [UIView animateWithDuration:SWIPE_DURATION
                   animations:^{
                     [self setCenter:view];
                   }];
}
/**
 * @brief  指定方向からコンプリートリストを呼び出し
 *
 * @param direction 呼び出す方向
 */
-(void)bringCompleteListFrom:(enum __LIST_DIRECTION__)direction
{
  /// @todo 要変更
  return;
  [self setCompleteMode];
  UIView *view = self.filterNavigationController.view;
  if (direction == __FROM_RIGHT__) {
    [self setRight:view];
  } else {
    [self setLeft:view];
  }
  [self.view bringSubviewToFront:view];
  [self.view bringSubviewToFront:self.tabBar];
  [UIView animateWithDuration:SWIPE_DURATION
                   animations:^{
                     [self setCenter:view];
                   }];
}

#pragma mark - リスト変更関数

-(void)setItemMode
{
  LOG(@"アイテムモードに設定");
  currentListMode_ = __ITEM_MODE__;
  [self.tabBar setItemMode];
}
-(void)setTagMode
{
  LOG(@"タグモードに設定");
  currentListMode_ = __TAG_MODE__;
  [self.tabBar setTagMode];
}
-(void)setFilterMode
{
  LOG(@"フィルターモードに設定");
  currentListMode_ = __FILTER_MODE__;
  [self.tabBar setFilterMode];
}
-(void)setCompleteMode
{
  currentListMode_ = __COMPLETE_MODE__;
  [self.tabBar setCompletedMode];
}

#pragma mark - リスト表示モード関数

-(void)changeMode:(enum __LIST_MODE__)from
               to:(enum __LIST_MODE__)to
{
  // 同じ場合は処理しない
  if (from == to) {
    return;
  }
  LOG(@"%u", currentListMode_);
  
  enum __LIST_DIRECTION__ direction;
  switch (from) {
    case __ITEM_MODE__:
      direction = __FROM_RIGHT__;
      break;
    case __TAG_MODE__:
      if (to == __ITEM_MODE__) {
        direction = __FROM_LEFT__;
      } else {
        direction = __FROM_RIGHT__;
      }
      break;
    case __FILTER_MODE__:
      if (to == __COMPLETE_MODE__) {
        direction = __FROM_RIGHT__;
      } else {
        direction = __FROM_LEFT__;
      }
      break;
    case __COMPLETE_MODE__:
      direction = __FROM_LEFT__;
      break;
    default:
      break;
  }
  switch (to) {
    case __ITEM_MODE__:
      [self bringItemListFrom:direction];
      break;
    case __TAG_MODE__:
      [self bringTagListFrom:direction];
      break;
    case __FILTER_MODE__:
      [self bringFilterListFrom:direction];
      break;
    case __COMPLETE_MODE__:
      [self bringCompleteListFrom:direction];
      break;
      
    default:
      break;
  }
}

-(void)toItemListMode
{
  LOG(@"アイテムリストモード");
  [self changeMode:currentListMode_
                to:__ITEM_MODE__];
}
-(void)toTagListMode
{
  [self changeMode:currentListMode_
                to:__TAG_MODE__];
}
-(void)toFilterListMode
{
  [self changeMode:currentListMode_
                to:__FILTER_MODE__];
}
-(void)toCompleteListMode
{
  [self changeMode:currentListMode_
                to:__COMPLETE_MODE__];
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
