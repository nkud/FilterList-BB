//
//  DetailViewController.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/22.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>
{
  NSArray *dataArray_;
}
- (NSArray *)dataArray;
@property UITableView *tableView;

-(NSString *)titleCellID;

#pragma mark - キャンセルボタン
- (void)addCancelButton:(UITableViewCell *)cell;
- (void)didTappedCancelButton:(id)sender;

@end
