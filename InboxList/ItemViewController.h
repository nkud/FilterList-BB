//
//  MasterViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "InputItemViewController.h"
#import "ItemDetailViewController.h"
#import "Item.h"
#import "ItemCell.h"

/**
 * @brief  アイテムリスト
 */
@interface ItemViewController : UITableViewController
<NSFetchedResultsControllerDelegate, InputItemViewControllerDelegate,
ItemDetailViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSString *selectedTagString;

@property (strong, nonatomic) NSString *title;

@property CGFloat triggerDragging;

/**
 *  タグのリストを取得する
 *
 *  @return タグのリスト
 */
//-(NSArray *)getTagList;

-(void)updateTableView;

@end
