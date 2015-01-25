//
//  DetailViewController.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/22.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>
{
  NSArray *dataArray_;
}
- (NSArray *)dataArray;
@property UITableView *tableView;

@property UIColor *themeColor;

-(NSString *)titleCellID;
-(NSString *)normalCellID;

#pragma mark - キャンセルボタン
- (void)addCancelButton:(UITableViewCell *)cell
                 action:(SEL)action;

@end
