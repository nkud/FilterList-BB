//
//  TagField.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/27.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TagFieldDelegate <NSObject>

- (void)backspaceWillDown;

@end

@interface TagField : UITextField

/**
 *  @todo どういうことか分からない
 */
@property (nonatomic, assign) id <TagFieldDelegate, UITextFieldDelegate> delegate;

@end
