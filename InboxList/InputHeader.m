//
//  InputHeader.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/02.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "InputHeader.h"

@implementation InputHeader

/**
 *  初期化
 *
 *  @param frame フレーム
 *
 *  @return インスタンス
 */
- (id)initWithFrame:(CGRect)frame
{
  int input_height = 40;
  CGRect field_rect = frame;
  frame.size.height = input_height;
  frame.origin.y -= input_height;

  self = [super initWithFrame:frame];
  self.backgroundColor = [UIColor greenColor];
  
  if (self)
  {
    // テキストフィールド初期化
    field_rect.size.height = input_height;
    field_rect.origin.y = 0;
    self.inputField = [[UITextField alloc] initWithFrame:field_rect];
    self.inputField.placeholder = @"new input...";
    self.inputField.delegate = self;
    [self addSubview:self.inputField];
    }
  return self;
}

/**
 *  入力を開始する
 */
-(void)activateInput
{
  NSLog(@"%s", __FUNCTION__);
  [self.inputField becomeFirstResponder]; // キーボードを出す
}

/**
 *  入力状態を終了する
 */
-(void)deactivateInput
{
  NSLog(@"%s", __FUNCTION__);
  [self.delegate quickInsertNewItem:self.inputField.text];
  self.inputField.text = @"";
  [self.inputField resignFirstResponder];
}

/**
 *  リターンが押された時の処理
 *
 *  @param textField <#textField description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  NSLog(@"%s", __FUNCTION__);
  [self deactivateInput]; // 入力状態を終了する
  return YES;
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
