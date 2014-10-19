//
//  TagDetailViewController.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/19.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagDetailViewControllerDelegte <NSObject>

- (void)dismissDetailView:(NSString *)title
                indexPath:(NSIndexPath *)indexPath
                 isNewTag:(BOOL)isNewTag;

@end

@interface TagDetailViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource,
UITextFieldDelegate>

@property UITableView *tableView;

@property NSString *tagTitle;
@property NSIndexPath *tagIndexPath;
@property BOOL isNewTag;

- (instancetype)initWithTitle:(NSString *)title
                    indexPath:(NSIndexPath *)indexPath
                     delegate:(id<TagDetailViewControllerDelegte>)delegate;

@property id<TagDetailViewControllerDelegte> delegate;

@end
