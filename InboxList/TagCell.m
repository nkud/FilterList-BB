//
//  TagCell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/03.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "TagCell.h"
#import "Header.h"
#import "Configure.h"

@implementation TagCell

/**
 * @brief  タグセル初期化
 *
 * @param style           スタイル
 * @param reuseIdentifier アイデンティティ
 *
 * @return セル
 */
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
  self = [super initWithStyle:style
              reuseIdentifier:reuseIdentifier];
  if (self)
  {
    // Initialization code
  }
  return self;
}

-(void)showItemSizeLabel:(BOOL)show
{
  CGFloat alpha;
  if (show) {
    alpha = 1.0f;
  } else {
    alpha = 0.0f;
  }
  self.labelForItemSize.alpha = alpha;
//  self.labelForDueToTodayItemsSize.alpha = alpha;
//  self.labelForOverDueItemsSize.alpha = alpha;
}

/**
 * @brief  編集モードにする
 *
 * @param editing  編集モード
 * @param animated アニメーション
 */
-(void)setEditing:(BOOL)editing
         animated:(BOOL)animated
{
  LOG(@"%ld", self.editingStyle);
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationDuration:0.3];
  if (editing == YES) {
    [self showItemSizeLabel:NO];
    self.labelForItemSize.alpha = 0;
  } else {
    [self showItemSizeLabel:YES];
  }
  [UIView commitAnimations];
  
  [super setEditing:editing
           animated:animated];
}

- (void)awakeFromNib
{
  // Initialization code
  // 文字色を設定
  self.labelForItemSize.textColor = GRAY_COLOR;
//  self.labelForDueToTodayItemsSize.textColor = DUE_TO_TODAY_COLOR;
//  self.labelForOverDueItemsSize.textColor = OVERDUE_COLOR;
  
  self.accessoryView = self.labelForItemSize;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

@end
