//
//  InputHeaderCell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/20.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "InputHeaderCell.h"

NSString *kPlaceholderForInputFiled = @"new item";

@implementation InputHeaderCell

- (void)awakeFromNib {
  // Initialization code
  self.inputField.placeholder = kPlaceholderForInputFiled;
  self.inputField.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 * @brief  リターンキーが押された時の処理
 *
 * @param textField テキストフィールド
 *
 * @return 真偽値
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  // キーボードを閉じる
  [self.delegate didInputtedNewItem:self.inputField.text];
  [self.inputField resignFirstResponder];
  return YES;
}

@end
