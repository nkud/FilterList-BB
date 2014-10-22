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

@interface ListViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UITabBarDelegate>


@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UITabBar *tabBar;

#pragma mark - デリゲート
@property id<ListViewControllerDelegate> delegateForList;

#pragma mark - アクセサリー
//-(UIButton *)newDisclosureIndicatorAccessory;

@property NSFetchedResultsController *fetchedResultsController;


#pragma mark - ナビゲーションバー
-(void)configureTitleWithString:(NSString *)title
                       subTitle:(NSString *)subTitle;
// ビューのタイトル
@property UIView *titleView;

#pragma mark - ナビゲーションバーボタン
-(UIBarButtonItem *)newEditTableButton;
-(UIBarButtonItem *)newInsertObjectButton;
-(void)didTappedEditTableButton;
-(void)didTappedInsertObjectButton;

-(void)aleartMessage:(NSString *)message;

@property UIButton *deleteAllButton;


@end
