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

@implementation __NavigationController

/**
 * @brief  ナビゲーションコントローラを初期化
 * @param rootViewController ルートビューコントローラ
 * @return インスタンス
 */
-(id)initWithRootViewController:(UIViewController *)rootViewController
{
  self = [super initWithRootViewController:rootViewController];
  if (self) {
    ;
  }
  return self;
}


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
