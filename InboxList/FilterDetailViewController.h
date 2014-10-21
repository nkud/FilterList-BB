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
                   isNewFilter:(BOOL)isNewFilter;

@end

/**
 * @brief  フィルター入力画面
 */
@interface FilterDetailViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, TagSelectViewControllerDelegate>

@property UITableView *tableView;

@property id<FilterDetailViewControllerDelegate> delegate;

@property NSString *titleForFilter;
@property NSSet *tagsForFilter;

@property BOOL isNewFilter;

- (instancetype)initWithFilterTitle:(NSString *)title
                               tags:(NSSet *)tags
                        isNewFilter:(BOOL)isNewFilter;

@end
