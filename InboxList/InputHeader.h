//
//  HeaderInput.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/02.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputHeaderDelegate <NSObject>

-(void)quickInsertNewItem:(NSString *)itemString;

@end

@interface InputHeader : UIView
<UITextFieldDelegate>

@property UITextField *inputField;

@property id <InputHeaderDelegate> delegate;

-(void)activateInput;
-(void)deactivateInput;

@end
