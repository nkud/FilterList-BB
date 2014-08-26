//
//  InputFilterViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/26.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputFilterDelegate <NSObject>

-(void)dismissInputFilterView:(NSString *)filterTitle
              tagsForSelected:(NSSet *)tagsForSelected;

@end

/// フィルター入力画面
@interface InputFilterViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputTitleField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITableView *tagTableView;

@property id <InputFilterDelegate> delegate;

@property NSFetchedResultsController *tagFetchedResultsController;

@end
