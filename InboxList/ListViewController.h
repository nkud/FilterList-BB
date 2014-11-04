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

-(void)deleteAllSelectedRows:(id)sender;

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

#pragma mark - 編集バー
@property UIView *editTabBar;
- (void)hideEditTabBar:(BOOL)hide;

-(void)aleartMessage:(NSString *)message;

@property UIButton *deleteAllButton;

-(void)instantMessage:(NSString *)message;

@end
