//
//  NavigationController.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/04.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "NavigationController.h"

@implementation NavigationController

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  CATransition *transition = [CATransition animation];
  transition.duration = 0.3f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  transition.type = kCATransitionFade;
	[self.view.layer addAnimation:transition forKey:nil];

  [super pushViewController:viewController animated:animated];
}

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
