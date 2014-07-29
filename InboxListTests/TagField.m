//
//  TagField.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/27.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "TagField.h"

@implementation TagField

/**
 *  初期化
 *
 *  @param frame <#frame description#>
 *
 *  @return <#return value description#>
 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/**
 *  バックスペースが押された時の処理
 */
-(void)deleteBackward
{
  [self.delegate backspaceWillDown];
  [super deleteBackward];
}

/**
 *  入力状態
 */
- (void)stateInput
{
  [self setBackgroundColor:[UIColor whiteColor]];
  [self setTextColor:[UIColor blackColor]];
}

/**
 *  確定状態
 */
- (void)stateFixed
{
  [self setBackgroundColor:[UIColor blueColor]];
  [self setTextColor:[UIColor whiteColor]];
  [self setFont:[UIFont fontWithName:@"menlo" size:10]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
