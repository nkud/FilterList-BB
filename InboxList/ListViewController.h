//
//  ListViewController.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/09/23.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

// ビューのタイトル
@property UIView *titleView;
-(void)configureTitleWithString:(NSString *)title
                      miniTitle:(NSString *)miniTitle;

@end
