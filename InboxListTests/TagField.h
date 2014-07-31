//
//  TagField.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/27.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TagField;

@protocol TagFieldDelegate <UITextFieldDelegate>

- (void)backspaceWillDown:(TagField *)sender;

@end

@interface TagField : UITextField

@property (nonatomic, assign) id <TagFieldDelegate> delegate;

- (void)stateInput;
- (void)stateFixed;

@end
