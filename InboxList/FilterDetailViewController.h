//
//  InputFilterViewController2.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/12.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagSelectViewController.h"

/**
 * @brief  フィルター入力画面プロトコル
 */
@protocol FilterDetailViewControllerDelegate <NSObject>

- (void)dismissInputFilterView:(NSString *)filterTitle
               tagsForSelected:(NSSet *)tagsForSelected
                     indexPath:(NSIndexPath *)indexPath
                   isNewFilter:(BOOL)isNewFilter;

@end

/**
 * @brief  フィルター入力画面
 */
@interface FilterDetailViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, TagSelectViewControllerDelegate, UITextFieldDelegate>

@property UITableView *tableView;

@property NSString *titleForFilter;
@property NSSet *tagsForFilter;
@property NSIndexPath *indexPathForFilter;
@property BOOL isNewFilter;
@property id<FilterDetailViewControllerDelegate> delegate;

- (instancetype)initWithFilterTitle:(NSString *)title
                               tags:(NSSet *)tags
                        isNewFilter:(BOOL)isNewFilter
                          indexPath:(NSIndexPath *)indexPath
                           delegate:(id<FilterDetailViewControllerDelegate>)delegate;

@end
