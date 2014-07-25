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
#import "FilterViewController.h"

@interface MainViewController : UIViewController
<MenuViewControllerDelegate> {
  int swipe_distance;
}

@property (strong, nonatomic) NavigationController   *navigationController;
@property (strong, nonatomic) MasterViewController   *masterViewController;
@property (strong, nonatomic) FilterViewController   *filterViewController;

@property (strong, nonatomic) MenuViewController     *menuViewController;

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

-(void)loadMasterViewForTag:(NSString *)tag fetcheResultController:(NSFetchedResultsController *)fetchedResultController;

@end