//
//  InputFilterViewController2.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/12.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputFilterViewController2 : UIViewController
<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property UITableView *tableView;

@property NSFetchedResultsController *tagFetchedResultsController;

@end
