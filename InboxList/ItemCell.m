//
//  Cell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ItemCell.h"
#import "Header.h"

static NSString *kCheckedImageName = @"checked@2x.png";
static NSString *kUncheckedImageName = @"unchecked@2x.png";

#pragma mark -

@implementation ItemCell

/**
 * 初期化する
 */
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  /* superで初期化 */
  self = [super initWithStyle:UITableViewCellStyleSubtitle
              reuseIdentifier:reuseIdentifier];
  if (self)
  {
    self.reminderLabel.text = @"none";
  }
  return self;
}

/**
 * @brief  チェックボックスを更新する
 *
 * @param isChecked 設定したいチェックの状態
 *
 * @return 変更後のチェックの状態
 */
-(BOOL)updateCheckBox:(BOOL)isChecked
{
  if (isChecked) {
    [self setChecked];
    return TRUE;
  } else {
    [self setUnChecked];
    return FALSE;
  }
}

/**
 * チェックをつける
 */
-(void)setChecked
{
  LOG(@"チェックを付ける");
  UIImage *check_true = [UIImage imageNamed:kCheckedImageName];
  [self.checkBoxImageView setImage:check_true];
}

/**
 * チェックをはずす
 */
- (void)setUnChecked
{
  LOG(@"チェックを外す");
  UIImage *check_false = [UIImage imageNamed:kUncheckedImageName];
  [self.checkBoxImageView setImage:check_false];
}


@end
