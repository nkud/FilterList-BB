//
//  MenuView.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputTagViewController.h"
#import "Tag.h"

static NSString * const TagModeCellIdentifier = @"TagCell";

/**
 * @brief  タグモード用のプロトコル
 */
@protocol TagViewControllerDelegate <NSObject>

- (void)didSelectedTag:(Tag *)tag;

@end

/**
 * @brief  タグリスト
 */
@interface TagViewController : UITableViewController
<NSFetchedResultsControllerDelegate, InputTagViewControllerProtocol>

@property (strong, nonatomic) NSArray *tagArray_;

@property (assign, nonatomic) id <TagViewControllerDelegate> delegate;

@property NSFetchedResultsController *fetchedResultsController;

- (void)updateTableView;

@end
