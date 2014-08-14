//
//  MainViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ItemViewController.h"
#import "NavigationController.h"
#import "TagViewController.h"
#import "FilterViewController.h"
#import "InputFilterViewController.h"
#import "TabBar.h"

@interface MainViewController : UIViewController
<TagViewControllerDelegate, UITabBarDelegate, FilterViewControllerDelegate,
InputFilterViewControlellerDelegate> {
  int swipe_distance;
}

/**
 *  コントローラー
 */
@property (strong, nonatomic) NavigationController       *navigationController;
@property (strong, nonatomic) ItemViewController         *itemViewController;
@property (strong, nonatomic) FilterViewController       *filterViewController;

@property (strong, nonatomic) TabBar                    *tabBar;

@property (strong, nonatomic) NavigationController *tagNavigationController;
@property (strong, nonatomic) TagViewController         *tagViewController;

-(void)loadMasterViewForTag:(NSString *)tag
     fetcheResultController:(NSFetchedResultsController *)fetchedResultController;

@end