//
//  InputFilterViewController2.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/12.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagSelectViewController.h"
#import "DetailViewController.h"

/**
 * @brief  フィルター入力画面プロトコル
 */
@protocol FilterDetailViewControllerDelegate <NSObject>

#pragma mark - 画面削除処理
- (void)dismissInputFilterView:(NSString *)filterTitle
               tagsForSelected:(NSSet *)tagsForSelected
                     indexPath:(NSIndexPath *)indexPath
                   isNewFilter:(BOOL)isNewFilter;

@end

/**
 * @brief  フィルター入力画面
 */
@interface FilterDetailViewController : DetailViewController
<TagSelectViewControllerDelegate, UITextFieldDelegate>

@property NSString *titleForFilter;
@property NSSet *tagsForFilter;
@property NSIndexPath *indexPathForFilter;
@property BOOL isNewFilter;
@property id<FilterDetailViewControllerDelegate> delegate;

#pragma mark - 期間セル用
@property NSIndexPath *indexPathForDatePickerCell;

#pragma mark - 初期化メソッド
- (instancetype)initWithFilterTitle:(NSString *)title
                               tags:(NSSet *)tags
                        isNewFilter:(BOOL)isNewFilter
                          indexPath:(NSIndexPath *)indexPath
                           delegate:(id<FilterDetailViewControllerDelegate>)delegate;

@end
