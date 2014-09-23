//
//  MainViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ItemViewController.h"
#import "ItemNavigationController.h"
#import "TagNavigationController.h"
#import "FilterNavigationController.h"
#import "TagViewController.h"
#import "FilterViewController.h"
#import "InputFilterViewController.h"
#import "TabBar.h"
#import "ListViewController.h"

/**
 リストモード変更の方向
 */
enum __LIST_DIRECTION__ {
  __FROM_LEFT__,
  __FROM_RIGHT__
};

/**
 * @brief  メインコンテナ
 */
@interface MainViewController : UIViewController
<TagViewControllerDelegate, UITabBarDelegate, FilterViewControllerDelegate, ListViewControllerDelegate> {
  int swipe_distance;
}

@property (strong, nonatomic) ItemNavigationController   *itemNavigationController;
@property (strong, nonatomic) ItemViewController         *itemViewController;

@property (strong, nonatomic) FilterNavigationController *filterNavigationController;
@property (strong, nonatomic) FilterViewController       *filterViewController;

@property (strong, nonatomic) TagNavigationController    *tagNavigationController;
@property (strong, nonatomic) TagViewController          *tagViewController;

@property (strong, nonatomic) TabBar                     *tabBar;


-(void)toItemListMode;
-(void)toTagListMode;
-(void)toFilterListMode;
-(void)toCompleteListMode;

-(void)loadItemViewForTitle:(NSString *)title
                       tags:(NSSet *)tags
     fetcheResultController:(NSFetchedResultsController *)fetchedResultController;

@end
