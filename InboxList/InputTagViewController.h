//
//  InputTagViewController.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/17.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputTagViewControllerProtocol <NSObject>

-(void)saveTags:(NSSet *)tagStrings;

@end

@interface InputTagViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property id<InputTagViewControllerProtocol> delegate;
@end