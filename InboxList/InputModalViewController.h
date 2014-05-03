//
//  InputModalViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/03/07.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputModalViewControllerDelegate;

/* -----------------------------------------------------------------------------
 * プロトコル
 * -------------------------------------------------------------------------- */
@protocol InputModalViewControllerDelegate <NSObject>
- (void)dismissInputModalView:(id)sender data:(NSArray *)data;
@end

/* -----------------------------------------------------------------------------
 * 宣言
 * -------------------------------------------------------------------------- */
@interface InputModalViewController : UIViewController
<UITextFieldDelegate>

@property id <InputModalViewControllerDelegate> delegate;

@property UITextField *textField;
@property UITextField *tagInputField;

@end
