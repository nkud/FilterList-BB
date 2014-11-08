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
    ;
  }
  return self;
}

-(void)viewDidLoad
{
  [super viewDidLoad];
  // バーを不透明に設定
  [self.navigationBar setTranslucent:NO];
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
  LOG(@"プッシュ");
  CATransition *transition = [CATransition animation];
  transition.duration = 0.3f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  
  transition.type = kCATransitionFade;
  
	[self.view.layer addAnimation:transition forKey:nil];

  [super pushViewController:viewController animated:animated];
}

-(void)pushViewControllerFromBottom:(UIViewController *)viewController
                           animated:(BOOL)animated
{
  LOG(@"プッシュ");
  CATransition *transition = [CATransition animation];
  transition.duration = 0.3f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
  
  transition.type = kCATransitionMoveIn;
  transition.subtype = kCATransitionFromTop;
  
  [self.view.layer addAnimation:transition forKey:nil];
  
  [super pushViewController:viewController animated:NO];
}

/**
 * @brief  ビューを削除する
 * @param animated アニメーション
 * @return ？？
 */
-(NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
  LOG(@"ポップ");
  CATransition *transition = [CATransition animation];
  transition.duration = 0.3f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  
  transition.type = kCATransitionFade;
  
	[self.view.layer addAnimation:transition forKey:nil];

  return [super popToRootViewControllerAnimated:animated];
}

-(NSArray *)popToRootViewControllerFromBottomAnimated:(BOOL)animated
{
  LOG(@"ポップ");
  CATransition *transition = [CATransition animation];
  transition.duration = 0.3f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  
  transition.type = kCATransitionMoveIn;
  transition.subtype = kCATransitionFromTop;
  
  [self.view.layer addAnimation:transition forKey:nil];
  
  return [super popToRootViewControllerAnimated:NO];
}
-(NSArray *)popToViewControllerFromBottom:(UIViewController *)viewController
                                 animated:(BOOL)animated
{
  LOG(@"ポップ");
  CATransition *transition = [CATransition animation];
  transition.duration = 0.3f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  
  transition.type = kCATransitionMoveIn;
  transition.subtype = kCATransitionFromBottom;
  
  [self.view.layer addAnimation:transition forKey:nil];
  
  return [super popToViewController:viewController animated:NO];
}

@end
