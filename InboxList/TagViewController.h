//
//  MenuView.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagViewControllerDelegate <NSObject>

- (void)selectedTag:(NSString *)tagString;

@end

@interface TagViewController : UITableViewController

@property (strong, nonatomic) NSArray *tag_list;

@property (assign, nonatomic) id <TagViewControllerDelegate> delegate;

- (void)updateTableView;

@end
