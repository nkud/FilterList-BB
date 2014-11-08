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

// IOBoutle
@property (weak, nonatomic) IBOutlet UITableView *tagTableView;

// コントローラー
@property NSFetchedResultsController *fetchedResultsController;

@property NSSet *tagsForAlreadySelected;

@property id <TagSelectViewControllerDelegate> delegate;

@property NSInteger maxCapacityRowsForSelected;

#pragma mark - 検索
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *tagSearchDisplayController;

@end
