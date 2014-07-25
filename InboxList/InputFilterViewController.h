//
//  InputFilterViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/25.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputFilterViewController : UIViewController
<UITextFieldDelegate>

/**
 *  入力フィールド
 */
@property UITextField * inputField;

@end
