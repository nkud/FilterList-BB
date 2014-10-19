//
//  ItemDetailDatePickerCell.m
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/14.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import "ItemDetailDatePickerCell.h"
#import "Header.h"

@implementation ItemDetailDatePickerCell

/**
 * @brief  初期化
 */
- (void)awakeFromNib
{
  // Initialization code
  // ピッカーの時間間隔を指定
  self.datePicker.minuteInterval = 10;
  self.datePicker.datePickerMode = UIDatePickerModeDate;
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
  [self.delegate didChangedDate:datePicker.date];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
  [dateFormatter setDateFormat:@"yyyy/MM/dd hh:mm"];
  NSString *dateString = [dateFormatter stringFromDate:datePicker.date];

  LOG(@"%@", dateString);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
