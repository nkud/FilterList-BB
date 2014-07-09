//
//  MenuView.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuViewControllerDelegate <NSObject>

- (void)loadMasterViewForTag:(NSString *)tag;

@end

@interface MenuViewController : UITableViewController

@property (strong, nonatomic) NSArray *tag_list;

@property (assign, nonatomic) id <MenuViewControllerDelegate> delegate;

- (void)updateTableView;

@end