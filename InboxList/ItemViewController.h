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
#import "ListViewController.h"

/**
 * @brief  アイテムリスト
 */
@interface ItemViewController : ListViewController
<NSFetchedResultsControllerDelegate, ItemDetailViewControllerDelegate, InputHeaderCellDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

//@property (strong, nonatomic) Tag *tagForSelected;

@property (strong, nonatomic) NSSet *selectedTags;

-(void)updateTableView;

-(void)showSectionHeader;
-(void)hideSectionHeader;

@end
