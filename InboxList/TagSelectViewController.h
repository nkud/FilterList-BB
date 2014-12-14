//
//  TagSelectViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/24.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagSelectViewControllerDelegate <NSObject>

-(void)dismissTagSelectView:(NSSet *)tagsForSelectedRows;

@end

/// タグ選択画面
@interface TagSelectViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate,
UISearchBarDelegate, UISearchControllerDelegate, UISearchDisplayDelegate>

#pragma mark - IBOutlet
//@property (weak, nonatomic) IBOutlet UITableView *tagTableView;
@property UITableView *tableView;

#pragma mark - コントローラー


#pragma mark - 検索
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *tagSearchDisplayController;

//@property UISearchBar *searchBar;
//@property UISearchDisplayController *tagSearchDisplayController;

#pragma mark - デリゲート
@property id <TagSelectViewControllerDelegate> delegate;

#pragma mark - その他
@property NSSet *tagsForAlreadySelected;

// 選択色
@property UIColor *selectColor;

// 最大選択可能数
@property NSInteger maxCapacityRowsForSelected;

@end
