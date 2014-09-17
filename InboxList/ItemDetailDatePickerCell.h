//
//  ItemDetailDatePickerCell.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/09/14.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ItemDetailDatePickerCellDelegate <NSObject>

-(void)didChangedDate:(NSDate *)date;

@end

/// ピッカーを持つセル
@interface ItemDetailDatePickerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property id <ItemDetailDatePickerCellDelegate> delegate;

@end
