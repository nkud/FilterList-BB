//
//  Cell.h
//  InboxList
//
//  Created by Naoki Ueda on 2014/05/03.
//  Copyright (c) 2014年 Naoki Ueda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemCell;

@protocol CellDelegate <NSObject>

- (void)tappedCheckBox:(ItemCell *)cell touch:(UITouch *)touch;

@end


@interface ItemCell : UITableViewCell

@property (strong, nonatomic) UIView *checkBox; /* チェックボックス */

@property (nonatomic, assign) id <CellDelegate> delegate;

- (BOOL)updateCheckBox:(BOOL)isChecked;

@end
