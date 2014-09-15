//
//  DetailViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Item.h"
#import "TagSelectViewController.h"

/**
 * @brief  詳細画面用プロトコル
 */
@protocol ItemDetailViewControllerDelegate <NSObject>

-(void)dismissDetailView:(id)sender
               indexPath:(NSIndexPath *)indexPath
             updatedItem:(Item *)updateditem;

@end

/**
 * @brief  詳細画面
 */
@interface ItemDetailViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, TagSelectViewControllerDelegate>

@property (strong, nonatomic) Item * detailItem;

@property id <ItemDetailViewControllerDelegate> delegate;

@property (strong, nonatomic) NSIndexPath *indexPathForItem;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
