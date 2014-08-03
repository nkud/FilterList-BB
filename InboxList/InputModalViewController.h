//
//  InputModalViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputModalViewControllerDelegate <NSObject>
- (void)dismissInputModalView:(id)sender
                         data:(NSArray *)data
                     reminder:(NSDate *)reminder;
@end

@interface InputModalViewController : UIViewController
<UITextFieldDelegate>

@property id <InputModalViewControllerDelegate> delegate;

//@property UITextField *textField;
//@property UITextField *tagInputField;
//@property UIDatePicker *remindPicker;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *titleInputField;
@property (weak, nonatomic) IBOutlet UITextField *tagInputField;
@property (weak, nonatomic) IBOutlet UIDatePicker *remindPicker;

@end
