//
//  InputFilterViewController2.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/12.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @brief  フィルター入力画面
 */
@interface InputFilterViewController2 : UIViewController
<UITableViewDelegate, UITableViewDataSource>

@property UITableView *tableView;

@end
