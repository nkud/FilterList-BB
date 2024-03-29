//
//  NavigationController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/04.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief  ナビゲーションコントローラインターフェイス
 */
@interface __NavigationController : UINavigationController

-(void)pushViewControllerFromBottom:(UIViewController *)viewController
                           animated:(BOOL)animated;

-(NSArray *)popToRootViewControllerFromBottomAnimated:(BOOL)animated;
-(NSArray *)popToViewControllerFromBottom:(UIViewController *)viewController
                                 animated:(BOOL)animated;

@end
