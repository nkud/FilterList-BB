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

@property UITextField *textField;
@property UITextField *tagInputField;
@property UIDatePicker *remindPicker;

@end
