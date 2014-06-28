//
//  MainViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MasterViewController.h"
#import "NavigationController.h"
#import "MenuViewController.h"

@interface MainViewController : UIViewController

@property (strong, nonatomic) NavigationController *navigationController;
@property (strong, nonatomic) MasterViewController *masterViewController;
@property (strong, nonatomic) MenuViewController *menuViewController;

@end
