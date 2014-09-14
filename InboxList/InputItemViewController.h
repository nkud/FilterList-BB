//
//  InputModalViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagSelectViewController.h"

/**
 * @brief  入力画面用のプロトコル
 */
@protocol InputItemViewControllerDelegate <NSObject>

//- (void)dismissInputModalView:(id)sender
//                         data:(NSArray *)data
//                     reminder:(NSDate *)reminder;

-(void)dismissInputItemView:(NSString *)itemTitle
        tagsForSelectedRows:(NSSet *)tagsForSelectedRows
                   reminder:(NSDate *)reminder;

@end

/**
 * @brief  入力画面
 */

@interface InputItemViewController : UIViewController
<UITextFieldDelegate, TagSelectViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property id <InputItemViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *titleInputField;

@property (weak, nonatomic) IBOutlet UIDatePicker *remindPicker;


@property (weak, nonatomic) IBOutlet UITableView *optionContainerTableView;

@property NSSet *selectedTags;
@property NSString *cellTitleForSelectedTags;

@end
