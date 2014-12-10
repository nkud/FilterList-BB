//
//  TagDetailViewController.h
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/19.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "NavigationController.h"

@protocol TagDetailViewControllerDelegte <NSObject>

- (void)dismissDetailView:(NSString *)title
                indexPath:(NSIndexPath *)indexPath
                 isNewTag:(BOOL)isNewTag;

@end

@interface TagDetailViewController : DetailViewController
<UITextFieldDelegate>

@property NSString *tagTitle;
@property NSIndexPath *tagIndexPath;
@property BOOL isNewTag;

@property __NavigationController *navigationController;

- (instancetype)initWithTitle:(NSString *)title
                    indexPath:(NSIndexPath *)indexPath
                     delegate:(id<TagDetailViewControllerDelegte>)delegate;

@property id<TagDetailViewControllerDelegte> delegate;

@end
