//
//  MainViewController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "MainViewController.h"
#import "Header.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/// @brief 初期化
///
-(id)init
{
  NSLog(@"%s", __FUNCTION__);
  self = [super init];
  return self;
}

/**
 * @brief マスタービュー上でスワイプ時の処理
 */
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer;
{
  NSLog(@"%s", __FUNCTION__);
  int distance = 200;
  CGPoint next_center = self.navigationController.view.center;
  CGFloat center_x = self.navigationController.view.center.x; // 現在の中心 x

  CGFloat screen_x = SCREEN_BOUNDS.size.width/2; // スクリーンの中心 x

  switch (recognizer.direction) {
      /* 右スワイプ */
    case UISwipeGestureRecognizerDirectionRight:
      next_center.x = center_x + distance;
      self.menuViewController.tag_list = [self.masterViewController getTagList]; ///< メニューの内容を更新して
      [self.menuViewController updateTableView]; ///< ビューを更新
      break;

      /* 左スワイプ */
    case UISwipeGestureRecognizerDirectionLeft:
      next_center.x = MAX(center_x-distance, screen_x);
      break;
    default:
      break;
  }
  [UIView animateWithDuration:0.2
                   animations:^{
                     self.navigationController.view.center = next_center;
                   }];
}
/**
 *
 */
- (void)viewDidLoad
{
  [super viewDidLoad];

  /// マスタービュー初期化
  self.masterViewController = [[MasterViewController alloc] initWithStyle:UITableViewStylePlain];
  self.masterViewController.managedObjectContext = self.managedObjectContext;

  /// ナビゲーションコントローラー初期化
  self.navigationController = [[NavigationController alloc] initWithRootViewController:self.masterViewController];

  /* ジェスチャーを設定 */
  UISwipeGestureRecognizer *recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                        action:@selector(handleSwipeFrom:)];
  UISwipeGestureRecognizer *recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(handleSwipeFrom:)];
  [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
  [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
  [self.navigationController.view addGestureRecognizer:recognizerRight];
  [self.navigationController.view addGestureRecognizer:recognizerLeft];


  self.navigationController.title = @"InboxList";
//  [self addChildViewController:self.navigationController];

  /// メニューバー初期化
  self.menuViewController = [[MenuViewController alloc] initWithNibName:nil bundle:nil];

  /// コントローラーのビューを配置
  [self.view addSubview:self.menuViewController.view];
  [self.view addSubview:self.navigationController.view];
}

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
