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

@interface MainViewController () {
  AppDelegate *app;
}
@end

@implementation MainViewController

/**
 *  フィルター入力画面を表示する
 */
-(void)presentInputFilterView
{
  LOG(@"フィルター入力画面を作成・表示");
  // 初期化
  InputFilterViewController *inputFilterView = [[InputFilterViewController alloc]
                                                initWithNibName:nil
                                                bundle:nil];
  inputFilterView.delegate = self;
  // 入力画面を最前面に表示する
  [self.view bringSubviewToFront:inputFilterView.view];
  // 入力画面を表示する
  [self presentViewController:inputFilterView
                     animated:YES
                   completion:nil];
}

/**
 *  フィルター入力画面を削除する
 *
 *  @param filterString 入力されたフィルター
 */
-(void)dismissInputView:(NSString *)filterString
{
  LOG(@"フィルターを削除");
  [self dismissViewControllerAnimated:YES
                           completion:nil];
}

/**
 * パラメータを初期化
 */
- (void)initParameter
{
  swipe_distance = SCREEN_BOUNDS.size.width - 50;
  app = [[UIApplication sharedApplication] delegate];
}

/**
 * 初期化
 */
-(id)init
{
  self = [super init];
  return self;
}

/**
 * マスタービューを中心に持ってくる
 */
- (void)moveMasterViewToCenter
{
  LOG(@"アイテムビューを中心に持ってくる");
  CGPoint next_center = self.navigationController.view.center;
  CGFloat center_x = self.navigationController.view.center.x; // 現在の中心 x

  CGFloat screen_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x
  next_center.x = MAX(center_x-swipe_distance, screen_x);

  /// アニメーション
  [UIView animateWithDuration:0.2
                   animations:^{
                     self.navigationController.view.center = next_center;
                   }];
}

/**
 *  マスタービュー上でスワイプされた時の処理
 *
 *  @param recognizer recognizer description
 */
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;
{
  switch (recognizer.direction)
  {
      // 右スワイプ
    case UISwipeGestureRecognizerDirectionRight:
      [self swipeDirectionRight];
      break;

      // 左スワイプ
    case UISwipeGestureRecognizerDirectionLeft:
      [self swipeDirectionLeft];
      break;

    default:
      break;
  }
}

/**
 *  アイテムリスト表示モード
 */
-(void)itemListMode
{
  LOG(@"アイテムリストモード");
  CGPoint next_center = self.navigationController.view.center;

  CGFloat screen_center_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x

  next_center.x = screen_center_x;

  [UIView animateWithDuration:0.2
                   animations:^{
                     self.navigationController.view.center = next_center;
                   }];
}

/**
 *  タグリスト表示モード
 */
-(void)tagListMode
{
  LOG(@"タグリストモード");
//  int distance = SCREEN_BOUNDS.size.width;
  CGPoint next_center = self.navigationController.view.center;
  CGFloat screen_center_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x

  self.tagViewController.tagArray_ = [CoreDataController getAllTagsArray];
  [self.tagViewController updateTableView]; //< ビューを更新

  next_center.x = screen_center_x + swipe_distance;
  [self.view sendSubviewToBack:self.filterViewController.view];
  
  [UIView animateWithDuration:0.2
                   animations:^{
                     self.navigationController.view.center = next_center;
                   }];
}
/**
 *  フィルターリスト表示モード
 */
-(void)filterListMode
{
  LOG(@"フィルターリストモード");
//  int distance = SCREEN_BOUNDS.size.width;
  CGPoint next_center = self.navigationController.view.center;
  CGFloat screen_center_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x

  next_center.x = screen_center_x - swipe_distance;
  [self.view sendSubviewToBack:self.tagNavigationController.view];

  [UIView animateWithDuration:0.2
                   animations:^{
                     self.navigationController.view.center = next_center;
                   }];
}

/**
 *  右方向スワイプ
 *
 * @todo 要改善
 */
- (void)swipeDirectionRight
{
  LOG(@"右にスワイプ");
  int distance = SCREEN_BOUNDS.size.width;
  CGPoint next_center = self.navigationController.view.center;
  CGFloat center_x = self.navigationController.view.center.x; // 現在の中心 x

  CGFloat screen_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x

  /**
   *  タグモード
   */
  if (center_x == screen_x) {
    [self.view sendSubviewToBack:self.filterViewController.view];
    self.tabBar.selectedItem = self.tabBar.tagModeTab;
  } else {
    self.tabBar.selectedItem = self.tabBar.itemModeTab;
  }
  next_center.x = center_x + distance;
  // 画面から消えないための処理
  if (next_center.x > SCREEN_BOUNDS.size.width*1.5) {
    return;
  }
  self.tagViewController.tagArray_ = [CoreDataController getAllTagsArray];
  [self.tagViewController updateTableView]; //< ビューを更新

  [UIView animateWithDuration:0.2
                   animations:^{
                     self.navigationController.view.center = next_center;
                   }];
}

/**
 *  中心にスワイプ
 */
- (void)swipeDirectionCenter
{
  LOG(@"中心にスワイプ");
  CGPoint next_center = self.navigationController.view.center;

  CGFloat screen_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x
  next_center.x = screen_x;

  [UIView animateWithDuration:0.2
                   animations:^{
                     self.navigationController.view.center = next_center;
                   }];
}

/**
 *  左方向スワイプ
 */
- (void)swipeDirectionLeft
{
  LOG(@"左方向にスワイプ");
  int distance = SCREEN_BOUNDS.size.width;
  CGPoint next_center = self.navigationController.view.center;
  CGFloat center_x = self.navigationController.view.center.x; // 現在の中心 x

  CGFloat screen_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x

  /**
   *  フィルターモード
   */
  if (center_x == screen_x) {
    [self.view sendSubviewToBack:self.tagNavigationController.view];
    self.tabBar.selectedItem = self.tabBar.filterModeTab;
  } else {
    self.tabBar.selectedItem = self.tabBar.itemModeTab;
  }
  //      next_center.x = MAX(center_x-distance, screen_x);
  next_center.x = center_x - distance;
  // 画面から消えないための処理
  if (next_center.x < -SCREEN_BOUNDS.size.width*0.5) {
    return;
  }
  [UIView animateWithDuration:0.2
                   animations:^{
                     self.navigationController.view.center = next_center;
                   }];
}
/**
 * ビューがロードされた後の処理
 */
- (void)viewDidLoad
{
  [super viewDidLoad];

  /// パラメータを初期化
  [self initParameter];

  LOG(@"アイテムビューを初期化");
  self.itemViewController = [[ItemViewController alloc] initWithStyle:UITableViewStylePlain];
  self.itemViewController.fetchedResultsController = [ResultControllerFactory fetchedResultsController:self.itemViewController]; // はじめは全アイテムを表示

  LOG(@"ナビゲーションコントローラー初期化");
  self.navigationController = [[NavigationController alloc] initWithRootViewController:self.itemViewController];

  /**
   *  タブバー初期化
   */
  LOG(@"タブバー初期化");
  self.tabBar = [[TabBar alloc] initWithFrame:CGRectMake(0,
                                                         SCREEN_BOUNDS.size.height-TABBAR_H,
                                                         SCREEN_BOUNDS.size.width,
                                                         TABBAR_H)];
  self.tabBar.delegate = self;

  LOG(@"フィルターコントローラーを初期化");
  self.filterViewController = [[FilterViewController alloc] initWithNibName:nil bundle:nil];
  self.filterViewController.delegate = self;

  LOG(@"ジェスチャーを設定");
  UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleSwipeFrom:)];
  UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleSwipeFrom:)];
  [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
  [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
  [self.navigationController.view addGestureRecognizer:recognizerRight];
  [self.navigationController.view addGestureRecognizer:recognizerLeft];

  self.navigationController.title = @"FilterList";

  LOG(@"タグモード初期化");
  self.tagViewController = [[TagViewController alloc] initWithNibName:nil
                                                               bundle:nil];
  self.tagViewController.delegate = self;
  self.tagViewController.fetchedResultsController = [CoreDataController tagFetchedResultsController:self.tagViewController];
  self.tagNavigationController = [[NavigationController alloc] initWithRootViewController:self.tagViewController];
  LOG(@"コントローラーを配置");
  [self.view addSubview:self.tagNavigationController.view];
  [self.view addSubview:self.filterViewController.view];
  [self.view addSubview:self.navigationController.view];
  [self.view addSubview:self.tabBar];
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
      LOG(@"左スワイプ");
      [self tagListMode];
      break;

    case 1:
      LOG(@"中心に戻る");
      [self itemListMode];
      break;

    case 2:
      LOG(@"右スワイプ");
      [self filterListMode];
      break;

    default:
      break;
  }
}

/**
 *  タグが選択された時の処理
 *
 *  @param tagString 選択されたタグの文字列
 */
-(void)selectedTag:(NSString *)tagString
{
  LOG(@"タグが選択された時の処理");
  if ([tagString isEqualToString:@""]) {
    [self loadMasterViewForTag:@"NO TAGS"
        fetcheResultController:[ResultControllerFactory fetchedResultsController:self.itemViewController]];
    return;
  }

  LOG(@"指定されたタグでロード");
  [self loadMasterViewForTag:tagString
      fetcheResultController:[ResultControllerFactory fetchedResultsControllerForTags:[NSSet setWithObject:tagString]
                                                                             delegate:self.itemViewController]];
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
- (void)loadMasterViewForTag:(NSString *)tag
      fetcheResultController:(NSFetchedResultsController *)fetchedResultController
{
  LOG(@"アイテムビューをロードする");
  [self itemListMode];
  self.itemViewController.selectedTagString = tag;//< 選択されたタグを渡して
  self.itemViewController.fetchedResultsController = fetchedResultController;
  [self.itemViewController updateTableView]; //< テーブルを更新
  [self.itemViewController setTitle:tag]; //< タグの名前に変える
  [self moveMasterViewToCenter]; //< マスタービューを中心に移動させる
}

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
