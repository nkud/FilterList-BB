//
//  ListViewController.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TagSelectViewController.h"

@class ListViewController;

@protocol ListViewControllerDelegate <NSObject>

-(void)openTabBar;
-(void)closeTabBar;

-(void)listWillEditMode;
-(void)listDidEditMode;

-(BOOL)isTopViewController:(ListViewController *)viewController;

-(void)didUpdateCoreData;

-(void)presentConfigureView;

@end

@interface ListViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, UITabBarDelegate,
UIActionSheetDelegate, TagSelectViewControllerDelegate>


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
-(void)deleteAllRows:(id)sender;

#pragma mark - ナビゲーションバー
-(void)configureTitleWithString:(NSString *)title
                       subTitle:(NSString *)subTitle
                       subColor:(UIColor *)subColor;
// ビューのタイトル
@property UIView *titleView;

-(void)scrollToTopCell;

#pragma mark - ナビゲーションバーボタン
-(UIBarButtonItem *)newEditTableButton;
-(UIBarButtonItem *)newInsertObjectButton;
-(void)didTappedEditTableButton;
-(void)didTappedInsertObjectButton;
-(void)toggleRightNavigationItemWithEditingState:(BOOL)isEditing;

@property UIColor *navbarThemeColor;

#pragma mark - 編集バー
@property UIView *editTabBar;
- (void)hideEditTabBar:(BOOL)hide;

-(void)aleartMessage:(NSString *)message;

- (void)updateEditTabBar;

@property UIButton *deleteAllButton;
@property UIButton *moveButton;

#pragma mark - インスタントメッセージ
-(void)instantMessage:(NSString *)message color:(UIColor *)color;

@end
