//
//  FilterViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/12.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewControllerDelegate <NSObject>

/**
 *  Viewを最前面に表示する
 *
 *  @param view 指定するビュー
 */
- (void)presentInputFilterView;

@end

@interface FilterViewController : UITableViewController

@property id <FilterViewControllerDelegate> delegate;

@end
