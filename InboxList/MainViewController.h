//
//  MainViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ItemViewController.h"
//#import "NavigationController.h"
#import "ItemNavigationController.h"
#import "TagNavigationController.h"
#import "FilterNavigationController.h"
#import "TagViewController.h"
#import "FilterViewController.h"
#import "InputFilterViewController.h"
#import "TabBar.h"

/**
 *  @brief  メイン
 */
@interface MainViewController : UIViewController
<TagViewControllerDelegate, UITabBarDelegate> {
  int swipe_distance;
}

@property (strong, nonatomic) ItemNavigationController   *itemNavigationController;
@property (strong, nonatomic) ItemViewController         *itemViewController;

@property (strong, nonatomic) FilterNavigationController *filterNavigationController;
@property (strong, nonatomic) FilterViewController       *filterViewController;

@property (strong, nonatomic) TagNavigationController    *tagNavigationController;
@property (strong, nonatomic) TagViewController          *tagViewController;

@property (strong, nonatomic) TabBar                    *tabBar;

-(void)loadMasterViewForTag:(NSString *)tag
     fetcheResultController:(NSFetchedResultsController *)fetchedResultController;

@end