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
  
  [self.oneDayButton setTitle:@"+1 day"
                     forState:UIControlStateNormal];
  [self.oneWeekButton setTitle:@"+1 week"
                      forState:UIControlStateNormal];
  [self.oneMonthButton setTitle:@"+1 month"
                       forState:UIControlStateNormal];
  
  self.selectionStyle = UITableViewCellSelectionStyleNone;

//  self.todayButton.layer.borderWidth = 0.5f;
//  self.oneDayButton.layer.borderWidth = 0.5f;
//  self.oneWeekButton.layer.borderWidth = 0.5f;
//  self.oneMonthButton.layer.borderWidth = 0.5f;
}

-(void)setTodayButton:(UIButton *)todayButton
{
  [todayButton setTitle:@"Today"
               forState:UIControlStateNormal];
}

-(void)setToday:(id)sender {
  [self.datePicker setDate:[NSDate date]
                  animated:YES];
  [self.delegate didChangedDate:self.datePicker.date];
}

- (IBAction)addOneDay:(id)sender {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = self.datePicker.date;
  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.day = 1;
  [self.datePicker setDate:[calendar dateByAddingComponents:components
                                                     toDate:date
                                                    options:0]
                  animated:YES];
  [self.delegate didChangedDate:self.datePicker.date];
}

- (IBAction)addOneWeek:(id)sender {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = self.datePicker.date;
  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.day = 7;
  [self.datePicker setDate:[calendar dateByAddingComponents:components
                                                     toDate:date
                                                    options:0]
                  animated:YES];
  [self.delegate didChangedDate:self.datePicker.date];
}

- (IBAction)addOneMonth:(id)sender {
  NSCalendar *calendar = [NSCalendar currentCalendar];
  NSDate *date = self.datePicker.date;
  NSDateComponents *components = [[NSDateComponents alloc] init];
  components.month = 1;
  [self.datePicker setDate:[calendar dateByAddingComponents:components
                                                     toDate:date
                                                    options:0]
                  animated:YES];
  [self.delegate didChangedDate:self.datePicker.date];
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
