//
//  ItemDetailDatePickerCell.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/14.
//  Copyright (c) 2014 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemDetailDatePickerCellDelegate <NSObject>

-(void)didChangedDate:(NSDate *)date;

@end

/// ピッカーを持つセル
@interface ItemDetailDatePickerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property id <ItemDetailDatePickerCellDelegate> delegate;

#pragma mark - ショートカットボタン
@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *oneDayButton;
@property (weak, nonatomic) IBOutlet UIButton *oneWeekButton;
@property (weak, nonatomic) IBOutlet UIButton *oneMonthButton;
- (IBAction)setToday:(id)sender;
- (IBAction)addOneDay:(id)sender;
- (IBAction)addOneWeek:(id)sender;
- (IBAction)addOneMonth:(id)sender;

@end
