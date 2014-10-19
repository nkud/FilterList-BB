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

- (void)awakeFromNib
{
  // Initialization code
  // 文字色を設定
  self.labelForItemSize.textColor = GRAY_COLOR;
  self.labelForDueToTodayItemsSize.textColor = DUE_TO_TODAY_COLOR;
  self.labelForOverDueItemsSize.textColor = OVERDUE_COLOR;
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

@end
