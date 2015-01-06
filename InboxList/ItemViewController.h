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
#import "NavigationController.h"

@protocol ItemViewControllerDelegate <NSObject>

-(void)didInputNewItem:(NSString *)title;

@end

/**
 * @brief  アイテムリスト
 */
@interface ItemViewController : ListViewController
<NSFetchedResultsControllerDelegate, ItemDetailViewControllerDelegate, InputHeaderCellDelegate,
UITextFieldDelegate>

//@property (strong, nonatomic) Tag *tagForSelected;

@property (strong, nonatomic) NSSet *selectedTags;

@property __NavigationController *navigationController;

@property NSIndexPath *indexPathForInputHeader;

@property id<ItemViewControllerDelegate> delegateForItemViewController;

-(void)updateTableView;

-(void)showSectionHeader;
-(void)hideSectionHeader;

@end
