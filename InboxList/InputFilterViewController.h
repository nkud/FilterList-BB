//
//  InputFilterViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/25.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TagFieldViewController.h"

@protocol InputFilterViewControlellerDelegate <NSObject>

- (void)dismissInputView:(NSSet *)filterStrings;

@end

@interface InputFilterViewController : UIViewController
<UITextFieldDelegate>

@property (strong, nonatomic) TagFieldViewController *tagFieldViewController;

@property id <InputFilterViewControlellerDelegate> delegate;

@end
