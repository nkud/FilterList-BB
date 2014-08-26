//
//  FilterViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/12.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputFilterViewController.h"

//@protocol FilterViewControllerDelegate <NSObject>
//
///**
// *  Viewを最前面に表示する
// *
// *  @param view 指定するビュー
// *  @todo メインには、画面の重なり順だけデリゲートするようにする。viewを渡して。
// */
//- (void)presentInputFilterView;
//
//@end

/**
 *  @brief  フィルターリスト
 */
@interface FilterViewController : UITableViewController
<NSFetchedResultsControllerDelegate, InputFilterDelegate>

//@property id <FilterViewControllerDelegate> delegate;

@property NSFetchedResultsController *fetchedResultsController;

@end
