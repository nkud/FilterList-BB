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
#import "CompleteViewController.h"
#import "CompleteNavigationController.h"

#import "FilterDetailViewController.h"

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

#pragma mark - リストモード -
#pragma mark - アイテムリスト
@property (strong, nonatomic) ItemNavigationController   *itemNavigationController;
@property (strong, nonatomic) ItemViewController         *itemViewController;

#pragma mark - フィルターリスト
@property (strong, nonatomic) FilterNavigationController *filterNavigationController;
@property (strong, nonatomic) FilterViewController       *filterViewController;

#pragma mark - タグリスト
@property (strong, nonatomic) TagNavigationController    *tagNavigationController;
@property (strong, nonatomic) TagViewController          *tagViewController;

#pragma mark - 完了リスト
@property (strong, nonatomic) CompleteNavigationController    *completeNavigationController;
@property (strong, nonatomic) CompleteViewController          *completeViewController;


#pragma mark - タブバー
@property (strong, nonatomic) TabBar                     *tabBar;


-(void)toItemListMode;
-(void)toTagListMode;
-(void)toFilterListMode;
-(void)toCompleteListMode;

-(void)loadItemViewForTitle:(NSString *)title
                       tags:(NSSet *)tags
     fetcheResultController:(NSFetchedResultsController *)fetchedResultController;

@end
