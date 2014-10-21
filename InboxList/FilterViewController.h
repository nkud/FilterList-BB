//
//  FilterViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/12.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterDetailViewController.h"
#import "ListViewController.h"

@protocol FilterViewControllerDelegate <NSObject>

/**
 *  @brief Viewを最前面に表示する
 *
 *  @param view 指定するビュー
 *  @todo メインには、画面の重なり順だけデリゲートするようにする。viewを渡して。
 */
//- (void)presentInputFilterView;

-(void)didSelectedFilter:(NSString *)filterTitle
                    tags:(NSSet *)tags;

@end

/**
 *  @brief  フィルターリスト
 */
@interface FilterViewController : ListViewController
<NSFetchedResultsControllerDelegate, FilterDetailViewControllerDelegate,
UITextFieldDelegate>

@property id <FilterViewControllerDelegate> delegate;

@property NSFetchedResultsController *fetchedResultsController;

@end
