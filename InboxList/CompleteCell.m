//
//  CompleteCell.m
//  FilterList
//
//  Created by Naoki Ueda on 2014/10/07.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "CompleteCell.h"
#import "Header.h"

@implementation CompleteCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:UITableViewCellStyleSubtitle
              reuseIdentifier:reuseIdentifier];
  if (self) {
    // チェックボックスを設定する
    self.checkBoxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    self.accessoryView = self.checkBoxImageView;
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
  UIImage *check_true = [UIImage imageNamed:@"checked.png"];
  [self.checkBoxImageView setImage:check_true];
}

/**
 * チェックをはずす
 */
- (void)setUnChecked
{
  LOG(@"チェックを外す");
  UIImage *check_false = [UIImage imageNamed:@"unchecked.png"];
  [self.checkBoxImageView setImage:check_false];
}

@end
