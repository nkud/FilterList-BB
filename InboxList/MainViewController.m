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
  NSLog(@"%@", filterString);
  [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 * パラメータを初期化
 */
- (void)initParameter
{
  swipe_distance = 200;
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

  switch (recognizer.direction) {
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

  /// アニメーション

}

/**
 *  右方向スワイプ
 *
 * @todo 要改善
 */
- (void)swipeDirectionRight
{
  NSLog(@"%s", __FUNCTION__);
  int distance = 200;
  CGPoint next_center = self.navigationController.view.center;
  CGFloat center_x = self.navigationController.view.center.x; // 現在の中心 x

  CGFloat screen_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x

  if (center_x == screen_x) {
    [self.view sendSubviewToBack:self.filterViewController.view];
  }
  next_center.x = center_x + distance;
  // 画面から消えないための処理
  if (next_center.x > SCREEN_BOUNDS.size.width*1.5) {
    return;
  }
  self.menuViewController.tag_list = [self.masterViewController getTagList]; //< メニューの内容を更新して
  [self.menuViewController updateTableView]; //< ビューを更新

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
  NSLog(@"%s", __FUNCTION__);
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
  NSLog(@"%s", __FUNCTION__);

  int distance = 200;
  CGPoint next_center = self.navigationController.view.center;
  CGFloat center_x = self.navigationController.view.center.x; // 現在の中心 x

  CGFloat screen_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x


  if (center_x == screen_x) {
    [self.view sendSubviewToBack:self.menuViewController.view];
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

  /// マスタービュー初期化
  self.masterViewController = [[MasterViewController alloc] initWithStyle:UITableViewStylePlain];

  /// ナビゲーションコントローラー初期化
  self.navigationController = [[NavigationController alloc] initWithRootViewController:self.masterViewController];

  /**
   *  タブバー初期化
   */
  int tab_bar_height = 100;
  self.tabBar = [[UITabBar alloc] initWithFrame:CGRectMake(0,
                                                           SCREEN_BOUNDS.size.height-tab_bar_height,
                                                           SCREEN_BOUNDS.size.width,
                                                           tab_bar_height)];
  UITabBarItem *tabItem1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:0];
  UITabBarItem *tabItem2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:1];
  UITabBarItem *tabItem3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:2];
  self.tabBar.items = [NSArray arrayWithObjects:tabItem1, tabItem2, tabItem3, nil];
  self.tabBar.delegate = self;
  self.tabBar.translucent = NO;

  self.tabBar.barStyle = UIBarStyleDefault;
  self.tabBar.tintColor = [UIColor blueColor];
  self.tabBar.selectedItem = tabItem2;

  /**
   *  フィルターコントローラーを初期化
   */
  self.filterViewController = [[FilterViewController alloc] initWithNibName:nil bundle:nil];
  self.filterViewController.delegate = self;

  /// ジェスチャーを設定
  UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleSwipeFrom:)];
  UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleSwipeFrom:)];
  [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
  [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
  [self.navigationController.view addGestureRecognizer:recognizerRight];
  [self.navigationController.view addGestureRecognizer:recognizerLeft];


  self.navigationController.title = @"FilterList";
//  [self addChildViewController:self.navigationController];

  /// メニューバー初期化
  self.menuViewController = [[MenuViewController alloc] initWithNibName:nil bundle:nil];
  self.menuViewController.delegate = self;

  /// コントローラーのビューを配置
  [self.view addSubview:self.menuViewController.view];
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
      /**
       *  左スワイプ
       */
    case 0:
      [self swipeDirectionRight];
      break;
      /**
       *  中心に戻る
       */
    case 1:
      [self swipeDirectionCenter];
      break;
      /**
       *  右スワイプ
       */
    case 2:
      [self swipeDirectionLeft];
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
  if ([tagString isEqualToString:@"all"]) {
    [self loadMasterViewForTag:@"all"
        fetcheResultController:[ResultControllerFactory fetchedResultsController:self.masterViewController]];
    return;
  }
  [self loadMasterViewForTag:tagString
      fetcheResultController:[ResultControllerFactory fetchedResultsControllerForTag:tagString
                                                                            delegate:self.masterViewController]];
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
  NSLog(@"%s", __FUNCTION__);
  self.masterViewController.selectedTagString = tag;//< 選択されたタグを渡して
  self.masterViewController.fetchedResultsController = fetchedResultController;
  [self.masterViewController updateTableView]; //< テーブルを更新
  [self.masterViewController setTitle:tag]; //< タグの名前に変える
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
