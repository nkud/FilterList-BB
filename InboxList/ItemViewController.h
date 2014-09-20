//
//  MasterViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "ItemDetailViewController.h"
#import "Item.h"
#import "ItemCell.h"
#import "InputHeaderCell.h"

/**
 * @brief  アイテムリスト
 */
@interface ItemViewController : UITableViewController
<NSFetchedResultsControllerDelegate, ItemDetailViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *selectedTagString;
@property (strong, nonatomic) NSString *title;
@property CGFloat triggerDragging;

@property InputHeaderCell *inputHeaderCell;

/**
 *  @brief タグのリストを取得する
 *
 *  @return タグのリスト
 */
//-(NSArray *)getTagList;

-(void)updateTableView;


@end
