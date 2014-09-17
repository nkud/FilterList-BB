//
//  ItemDetailDatePickerCell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/14.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import "ItemDetailDatePickerCell.h"

@implementation ItemDetailDatePickerCell

- (void)awakeFromNib
{
  // Initialization code
  
  // ピッカーの時間間隔を指定
  self.datePicker.minuteInterval = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
