//
//  NavigationController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/04.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "NavigationController.h"
#import "Header.h"
#import "Configure.h"

@interface __NavigationController ()

@end

@implementation __NavigationController

/**
 * @brief  ナビゲーションコントローラを初期化
 * @param rootViewController ルートビューコントローラ
 * @return インスタンス
 */
-(id)initWithRootViewController:(UIViewController *)rootViewController
{
  self = [super initWithRootViewController:rootViewController];
  if (self)
  {
//    [self initTitleView];
  }
  return self;
}

-(void)initTitleView
{
  // タイトルビューを設定
  // ナビゲーションバーのtitleに表示する独自Viewを作成します。
  self.titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
  self.titleView.backgroundColor = [UIColor redColor];
  self.titleView.opaque = NO;
  // 以下のように代入して、タイトルに独自Viewを表示します。
  self.navigationItem.titleView = self.titleView;
  
  // 1行目に表示するラベルを作成して、
  // 上記で作成した独自Viewに追加します。
  self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 195, 20)];
  self.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
  self.titleLabel.text = @"RSS";
  self.titleLabel.textColor = [UIColor whiteColor];
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.backgroundColor = [UIColor clearColor];
  [self.titleView addSubview:self.titleLabel];
  
  // 2行目に表示するラベルを作成して、
  // 上記で作成した独自Viewに追加します。
  self.miniLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 195, 20)];
  self.miniLabel.font = [UIFont boldSystemFontOfSize:10.0f];
  self.miniLabel.textColor = [UIColor colorWithRed:104.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
  self.miniLabel.textAlignment = NSTextAlignmentCenter;
  self.miniLabel.backgroundColor = [UIColor clearColor];
  self.miniLabel.adjustsFontSizeToFitWidth = YES;
  self.miniLabel.text = @"label test";
  [self.titleView addSubview:self.miniLabel];
}

-(void)viewDidLoad
{
  [super viewDidLoad];
  // バーを不透明に設定
  [self.navigationBar setTranslucent:NO];
  [self initTitleView];
}

/// @todo アニメーションも設定できるようにする
/**
 * @brief  ビューを表示させる
 * @param viewController 表示させるビュー
 * @param animated       アニメーション
 */
-(void)pushViewController:(UIViewController *)viewController
                 animated:(BOOL)animated
{
  CATransition *transition = [CATransition animation];
  transition.duration = 0.3f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];

  [super pushViewController:viewController animated:animated];
}

/**
 * @brief  ビューを削除する
 * @param animated アニメーション
 * @return ？？
 */
-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
  CATransition *transition = [CATransition animation];
  transition.duration = 0.3f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];

  return [super popToRootViewControllerAnimated:animated];
}

@end
