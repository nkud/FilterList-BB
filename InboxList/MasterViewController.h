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
#import "Cell.h"

@interface MasterViewController : UITableViewController
<NSFetchedResultsControllerDelegate, InputModalViewControllerDelegate,
DetailViewControllerDelegate, CellDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

-(NSArray *)getTagList; ///< タグのリストを取得する

@end
