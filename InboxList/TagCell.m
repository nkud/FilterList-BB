//
//  TagCell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/08/03.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "TagCell.h"
#import "Header.h"

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
  LOG(@"タグセルを初期化");
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
  LOG(@"Nibファイルから起動");
  // Initialization code
}

- (void)setSelected:(BOOL)selected
           animated:(BOOL)animated
{
  LOG(@"選択された??");
  [super setSelected:selected animated:animated];
  // Configure the view for the selected state
}

@end
