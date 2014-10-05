//
//  ListViewController.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/09/23.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ListViewControllerDelegate <NSObject>

-(void)openTabBar;
-(void)closeTabBar;

@end

@interface ListViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// ビューのタイトル
@property UIView *titleView;
-(void)configureTitleWithString:(NSString *)title
                       subTitle:(NSString *)subTitle;

@property id<ListViewControllerDelegate> delegateForList;

@end
