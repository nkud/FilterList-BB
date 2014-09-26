//
//  TagSelectViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/24.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagSelectViewControllerDelegate <NSObject>

-(void)dismissTagSelectView:(NSSet *)tagsForSelectedRows;

@end

/// タグ選択画面
@interface TagSelectViewController : UIViewController
<UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tagTableView;
@property (weak, nonatomic) IBOutlet UITextField *inputField;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property NSFetchedResultsController *fetchedResultsController;

@property NSSet *tagsForAlreadySelected;

@property id <TagSelectViewControllerDelegate> delegate;

@end
