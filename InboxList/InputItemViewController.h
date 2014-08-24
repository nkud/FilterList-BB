//
//  InputModalViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagFieldViewController.h"
#import "TagSelectViewController.h"

@protocol InputItemViewControllerDelegate <NSObject>

//- (void)dismissInputModalView:(id)sender
//                         data:(NSArray *)data
//                     reminder:(NSDate *)reminder;

-(void)dismissInputItemView:(NSString *)title
        tagsForSelectedRows:(NSSet *)tagsForSelectedRows
                   reminder:(NSDate *)reminder;

@end

@interface InputItemViewController : UIViewController
<UITextFieldDelegate, TagSelectViewControllerDelegate>

@property id <InputItemViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *titleInputField;

@property (weak, nonatomic) IBOutlet UIDatePicker *remindPicker;

@property (weak, nonatomic) IBOutlet UIButton *buttonTagSelectView;
@property (weak, nonatomic) IBOutlet UILabel *selectedTagsLabel;

@property NSSet *selectedTags;

@end
