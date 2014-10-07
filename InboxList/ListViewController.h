//
//  ListViewController.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListViewControllerDelegate <NSObject>

-(void)openTabBar;
-(void)closeTabBar;

@end

@interface ListViewController : UITableViewController

// ビューのタイトル
@property UIView *titleView;

/**
 * @brief  ナビゲーションバーを設定
 *
 * @param title    メインタイトル
 * @param subTitle サブタイトル
 */
-(void)configureTitleWithString:(NSString *)title
                       subTitle:(NSString *)subTitle;

@property id<ListViewControllerDelegate> delegateForList;

@end
