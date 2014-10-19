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
#import "ListViewController.h"
#import "TagDetailViewController.h"

static NSString * const TagModeCellIdentifier = @"TagCell";

/**
 * @brief  タグモード用のプロトコル
 */
@protocol TagViewControllerDelegate <NSObject>

- (void)didSelectTag:(Tag *)tag;

@end

/**
 * @brief  タグリスト
 */
@interface TagViewController : ListViewController
<NSFetchedResultsControllerDelegate, InputTagViewControllerProtocol, TagDetailViewControllerDelegte>

@property (strong, nonatomic) NSArray *tagArray_;

@property (assign, nonatomic) id <TagViewControllerDelegate> delegate;

@property NSFetchedResultsController *fetchedResultsController;

- (void)updateTableView;

@end
