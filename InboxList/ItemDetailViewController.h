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
                   title:(NSString *)title
                    tags:(NSSet *)tags
                reminder:(NSDate *)reminder
               indexPath:(NSIndexPath *)indexPath
               isNewItem:(BOOL)isNewItem;

@end

/**
 * @brief  詳細画面
 */
@interface ItemDetailViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, TagSelectViewControllerDelegate>

@property (strong, nonatomic) NSString *titleForItem;
@property (strong, nonatomic) NSSet *tagsForItem;
@property (strong, nonatomic) NSDate *reminderForItem;
@property (strong, nonatomic) NSIndexPath *indexPathForItem;

@property NSIndexPath *indexPathForDatePickerCell;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property id <ItemDetailViewControllerDelegate> delegate;

@property BOOL isNewItem;

-(ItemDetailViewController *)initWithTitle:(NSString *)title
                                      tags:(NSSet *)tags
                                  reminder:(NSDate *)reminder
                                 indexPath:(NSIndexPath *)indexPath
                                  delegate:(id<ItemDetailViewControllerDelegate>)delegate;


@end
