//
//  InputHeader.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/02.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "InputHeader.h"
#import "Header.h"

@implementation InputHeader

/**
 *  初期パラメータを設定
 */
-(void)setParameter
{
  [self setHeight:40];
}

/**
 *  初期化
 *
 *  @param frame フレーム
 *
 *  @return インスタンス
 */
- (id)initWithFrame:(CGRect)frame
{
  [self setParameter];

  CGRect input_frame = frame;
  input_frame.origin.y += STATUSBAR_H + NAVBAR_H;
  input_frame.size.height = self.height;
  self = [super initWithFrame:input_frame];

  self.backgroundColor = [UIColor grayColor];
  
  if (self)
  {
    // テキストフィールド初期化
    CGRect field_rect = input_frame;
    field_rect.size.height = self.height;
    field_rect.origin.y = 0;
    self.inputField = [[UITextField alloc] initWithFrame:field_rect];
    self.inputField.placeholder = @"Add new item";
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
  LOG(@"入力を開始する");
//  [self.delegate setFrameForInputField]; // フィールドを出す
  [self.inputField becomeFirstResponder]; // キーボードを出す
}

/**
 *  入力状態を終了する
 */
-(void)deactivateInput
{
  LOG(@"入力状態を終了する");
  [self.delegate quickInsertNewItem:self.inputField.text];
  self.inputField.text = @"";
//  [self.delegate recoverFrameForInputField];
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
  LOG(@"リターン時の処理");
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
