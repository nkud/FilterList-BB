//
//  MasterViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "InputModalViewController.h"
#import "DetailViewController.h"
#import "Item.h"

@interface MasterViewController : UITableViewController
<NSFetchedResultsControllerDelegate,
InputModalViewControllerDelegate,
DetailViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (void)swipeView:(UISwipeGestureRecognizer *)sender;

@end
