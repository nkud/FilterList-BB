//
//  MenuView.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/06/23.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const TagModeCellIdentifier = @"TagCell";

@protocol TagViewControllerDelegate <NSObject>

- (void)selectedTag:(NSString *)tagString;

@end

@interface TagViewController : UITableViewController

//@property (strong, nonatomic) NSArray *tag_list;
@property (strong, nonatomic) NSArray *tagArray_;

@property (assign, nonatomic) id <TagViewControllerDelegate> delegate;

- (void)updateTableView;

@end
