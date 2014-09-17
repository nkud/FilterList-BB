//
//  ItemDetailDatePickerCell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/14.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ItemDetailDatePickerCell.h"

@implementation ItemDetailDatePickerCell

/**
 * @brief  初期化
 */
- (void)awakeFromNib
{
  // Initialization code
  // ピッカーの時間間隔を指定
  self.datePicker.minuteInterval = 10;
  [self.datePicker addTarget:self
                      action:@selector(pickerDidChangedValue:)
            forControlEvents:UIControlEventValueChanged];
}

/**
 * @brief  ピッカーの値が変更された時の処理
 *
 * @param datePicker ピッカー
 */
-(void)pickerDidChangedValue:(UIDatePicker *)datePicker
{
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
  [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm"];
  NSString *dateString = [dateFormatter stringFromDate:datePicker.date];
  
  NSLog(@"%s %@", __FUNCTION__, dateString);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
