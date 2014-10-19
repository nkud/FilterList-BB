//
//  ItemDetailTitleCell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/14.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ItemDetailTitleCell.h"

@implementation ItemDetailTitleCell

#pragma mark - 初期化

/**
 * @brief  初期化
 */
- (void)awakeFromNib
{
  // Initialization code
//  self.titleField.delegate = self;
}

#pragma mark - セルの処理

/**
 * @brief  選択された時のアニメーション？
 *
 * @param selected <#selected description#>
 * @param animated アニメーション
 */
- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
  [super setSelected:NO
            animated:NO];
  
  // Configure the view for the selected state
}

#pragma mark - テキストフィールドの処理

/**
 * @brief  リターンキーが押された時の処理
 *
 * @param textField テキストフィールド
 *
 * @return 処理の可否
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self.titleField resignFirstResponder];
  return YES;
}

@end
