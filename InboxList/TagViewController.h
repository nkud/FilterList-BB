//
//  MenuView.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tag.h"
#import "ListViewController.h"
#import "TagDetailViewController.h"

#import "InputHeaderCell.h"

static NSString * const TagModeCellIdentifier = @"TagCell";

/**
 * @brief  タグモード用のプロトコル
 */
@protocol TagViewControllerDelegate <NSObject>

- (void)didSelectTag:(Tag *)tag;
-(void)willDeleteTag:(Tag *)tag;

@end

/**
 * @brief  タグリスト
 */
@interface TagViewController : ListViewController
<NSFetchedResultsControllerDelegate, TagDetailViewControllerDelegte,
InputHeaderCellDelegate>

@property (strong, nonatomic) NSArray *tagArray_;

@property (assign, nonatomic) id <TagViewControllerDelegate> delegate;

@property __NavigationController *navigationController;

- (void)updateTableView;

@end
