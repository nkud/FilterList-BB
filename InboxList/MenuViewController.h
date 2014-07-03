//
//  MenuView.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UITableViewController

@property (strong, nonatomic) NSArray *tag_list;

- (void)updateTableView;

@end