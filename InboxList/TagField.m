//
//  TagField.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/07/27.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "TagField.h"

enum __INPUT_STATE__ {
  __INPUT__,
  __NEW_INPUT__
};

@interface TagField () {
  enum __INPUT_STATE__ input_state_;
}

@end

@implementation TagField


/**
 *  リターンキーが押された時の処理
 *
 *  @param textField 押されたテキストフィールド
 *
 *  @return ???
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  switch (input_state_) {
      // 入力途中
    case __INPUT__:

      break;
      // 入力完了状態
    case __NEW_INPUT__:
      [textField resignFirstResponder];
      break;

    default:
      break;
  }
  return NO;
}

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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
