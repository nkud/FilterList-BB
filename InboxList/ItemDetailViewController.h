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

- (void)dismissDetailView:(id)sender
                    index:(NSIndexPath *)indexPath
                itemTitle:(NSString *)itemTitle
                tagTitles:(NSArray *)tagTitles;

@end

/**
 * @brief  詳細画面
 */
@interface ItemDetailViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, TagSelectViewControllerDelegate>

@property (strong, nonatomic) Item * detailItem;

@property id <ItemDetailViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextField *tagField;

@property (strong, nonatomic) NSIndexPath *index;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
